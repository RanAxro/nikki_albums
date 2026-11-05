import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/utils/file_hash.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:path/path.dart" as p;

import "../model/hot_update_info.dart";

Future<String> getHotUpdatePath() async {
  return p.join((await getAppDataDirectoryPath()).path, "HotUpdate");
}

Future<String> getHotUpdateAssetsPath(String id) async {
  return p.join(await getHotUpdatePath(), id);
}

typedef HotUpdateAssetsPathProvider = Future<String> Function(String id);
typedef HotUpdateFileDownloader =
    Future<void> Function(String url, String savePath);

class HotUpdateChecksumException implements Exception {
  final String filePath;
  final String expectedSha256;
  final String actualSha256;

  const HotUpdateChecksumException({
    required this.filePath,
    required this.expectedSha256,
    required this.actualSha256,
  });

  @override
  String toString() {
    return "SHA-256 mismatch for $filePath: expected $expectedSha256, "
        "actual $actualSha256";
  }
}

class HotUpdater {
  HotUpdater({
    HotUpdateAssetsPathProvider? assetsPathProvider,
    HotUpdateFileDownloader? downloader,
    this.maxConcurrentDownloads = 3,
    this.maxAttempts = 4,
    this.retryDelay,
  }) : assert(maxConcurrentDownloads > 0),
       assert(maxAttempts > 0),
       _assetsPathProvider = assetsPathProvider ?? getHotUpdateAssetsPath,
       _downloader = downloader;

  final HotUpdateAssetsPathProvider _assetsPathProvider;
  final HotUpdateFileDownloader? _downloader;
  final int maxConcurrentDownloads;
  final int maxAttempts;
  final Duration Function(int retryNumber)? retryDelay;

  static final RegExp _sha256Pattern = RegExp(r"^[a-fA-F0-9]{64}$");
  static Future<void> _updateTail = Future<void>.value();

  Future<bool> update(
    List<HotUpdateInfo> infos, {
    void Function(double progress)? onProgress,
    bool check = true,
  }) {
    // The frame can rebuild while an update is still running. Serializing the
    // whole operation prevents two downloads from replacing the same directory.
    return _serialize(
      () => _update(infos, onProgress: onProgress, check: check),
    );
  }

  Future<bool> _update(
    List<HotUpdateInfo> infos, {
    void Function(double progress)? onProgress,
    required bool check,
  }) async {
    if (infos.isEmpty) return false;

    final List<_PreparedUpdate> updates = <_PreparedUpdate>[];
    for (final HotUpdateInfo info in infos) {
      final String id = _validatePathSegment(info.id, "update id");
      final String versionId = _validatePathSegment(
        info.versionId,
        "version id",
      );
      final String rootPath = p.normalize(await _assetsPathProvider(id));
      final File versionFile = File(p.join(rootPath, versionId));

      if (check && await versionFile.exists()) continue;

      final List<_PreparedFile> files = <_PreparedFile>[];
      final Set<String> paths = <String>{};
      for (final FileHotUpdateInfo fileInfo in info.files) {
        final String relativePath = _validateRelativePath(fileInfo.path);
        final String pathKey = Platform.isWindows || Platform.isMacOS
            ? relativePath.toLowerCase()
            : relativePath;
        if (!paths.add(pathKey)) {
          throw FormatException(
            "Duplicate hot-update file path: ${fileInfo.path}",
          );
        }

        files.add(
          _PreparedFile(
            relativePath: relativePath,
            downloadLink: fileInfo.downloadLink,
            sha256: _validateSha256(fileInfo.sha256),
          ),
        );
      }

      // An empty package has nothing to download or cache.
      if (files.isEmpty) continue;

      updates.add(
        _PreparedUpdate(
          id: id,
          versionId: versionId,
          rootPath: rootPath,
          files: files,
        ),
      );
    }

    if (updates.isEmpty) return false;

    final int totalFiles = updates.fold<int>(
      0,
      (int total, _PreparedUpdate update) => total + update.files.length,
    );
    int completedFiles = 0;
    onProgress?.call(0);

    final Dio? dio = _downloader == null
        ? Dio(
            BaseOptions(
              headers: <String, String>{"User-Agent": "Nikki Albums/$version"},
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(minutes: 2),
            ),
          )
        : null;

    try {
      for (final _PreparedUpdate update in updates) {
        await _downloadUpdate(
          update,
          dio: dio,
          onFileCompleted: () {
            completedFiles++;
            onProgress?.call(completedFiles / totalFiles);
          },
        );
      }
    } finally {
      dio?.close(force: true);
    }

    return true;
  }

  Future<void> _downloadUpdate(
    _PreparedUpdate update, {
    required Dio? dio,
    required void Function() onFileCompleted,
  }) async {
    final Directory parentDir = Directory(p.dirname(update.rootPath));
    await parentDir.create(recursive: true);

    final Directory stagingDir = await parentDir.createTemp(
      ".${update.id}.staging-",
    );
    bool committed = false;

    try {
      final List<Future<void> Function()> tasks = <Future<void> Function()>[];
      for (final _PreparedFile file in update.files) {
        tasks.add(() async {
          final String savePath = p.canonicalize(
            p.join(stagingDir.path, file.relativePath),
          );
          if (!p.isWithin(p.canonicalize(stagingDir.path), savePath)) {
            throw FormatException(
              "Hot-update file escapes its package directory: "
              "${file.relativePath}",
            );
          }

          await Directory(p.dirname(savePath)).create(recursive: true);
          await _downloadFileWithRetry(file, savePath: savePath, dio: dio);
          onFileCompleted();
        });
      }

      await _runWithConcurrency(tasks, maxConcurrency: maxConcurrentDownloads);

      await File(
        p.join(stagingDir.path, update.versionId),
      ).create(recursive: true);

      await _commitUpdate(stagingDir, update);
      committed = true;
    } finally {
      if (!committed) {
        await _safeDeleteDirectory(stagingDir);
      }
    }
  }

  Future<void> _downloadFileWithRetry(
    _PreparedFile file, {
    required String savePath,
    required Dio? dio,
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        await _safeDeleteFile(savePath);
        final HotUpdateFileDownloader? downloader = _downloader;
        if (downloader == null) {
          await dio!.download(file.downloadLink, savePath);
        } else {
          await downloader(file.downloadLink, savePath);
        }

        final File downloadedFile = File(savePath);
        if (!await downloadedFile.exists()) {
          throw FileSystemException(
            "Download completed without creating a file",
            savePath,
          );
        }

        await _verifySha256(downloadedFile, file.sha256);
        return;
      } catch (error, stackTrace) {
        await _safeDeleteFile(savePath);
        if (attempt >= maxAttempts || !_isRetryable(error)) {
          Error.throwWithStackTrace(error, stackTrace);
        }

        final Duration delay =
            retryDelay?.call(attempt) ??
            Duration(seconds: 1 << attempt); // 2s, 4s, 8s
        if (delay > Duration.zero) {
          await Future<void>.delayed(delay);
        }
      }
    }
  }

  Future<void> _verifySha256(File file, String? expectedSha256) async {
    if (expectedSha256 == null) return;

    final String actualSha256 = await calculateFileHashStreamString(file);
    if (actualSha256.toLowerCase() != expectedSha256) {
      throw HotUpdateChecksumException(
        filePath: file.path,
        expectedSha256: expectedSha256,
        actualSha256: actualSha256,
      );
    }
  }

  Future<void> _commitUpdate(
    Directory stagingDir,
    _PreparedUpdate update,
  ) async {
    final Directory rootDir = Directory(update.rootPath);
    if (!await rootDir.exists()) {
      await stagingDir.rename(rootDir.path);
      return;
    }

    final Directory parentDir = rootDir.parent;
    final Directory backupSlot = await parentDir.createTemp(
      ".${update.id}.backup-",
    );
    await backupSlot.delete();

    final Directory backupDir = Directory(backupSlot.path);
    await rootDir.rename(backupDir.path);

    try {
      await stagingDir.rename(rootDir.path);
    } catch (error, stackTrace) {
      Object? rollbackError;
      try {
        if (await backupDir.exists()) {
          await backupDir.rename(rootDir.path);
        }
      } catch (error) {
        rollbackError = error;
      }

      if (rollbackError != null) {
        throw StateError(
          "Failed to install hot update and restore the previous version: "
          "$error; rollback error: $rollbackError",
        );
      }
      Error.throwWithStackTrace(error, stackTrace);
    }

    // A failed cleanup must not invalidate an otherwise successful update.
    await _safeDeleteDirectory(backupDir);
  }

  bool _isRetryable(Object error) {
    if (error is HotUpdateChecksumException) return true;
    if (error is! DioException) return false;

    final DioExceptionType type = error.type;
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError) {
      return true;
    }
    if (type == DioExceptionType.badResponse) {
      final int? statusCode = error.response?.statusCode;
      return statusCode == 408 ||
          statusCode == 429 ||
          (statusCode != null && statusCode >= 500);
    }
    if (type == DioExceptionType.unknown) {
      return error.error is SocketException ||
          error.error is HandshakeException ||
          error.error is HttpException;
    }
    if (type == DioExceptionType.badCertificate ||
        type == DioExceptionType.cancel) {
      return false;
    }

    // transformTimeout was added in newer Dio versions. Comparing by enum name
    // keeps this code compilable with both old and new lockfiles.
    return type.name == "transformTimeout";
  }

  Future<void> _runWithConcurrency(
    List<Future<void> Function()> tasks, {
    required int maxConcurrency,
  }) async {
    int nextTask = 0;

    Future<void> worker() async {
      while (nextTask < tasks.length) {
        final Future<void> Function() task = tasks[nextTask++];
        await task();
      }
    }

    final int workerCount = tasks.length < maxConcurrency
        ? tasks.length
        : maxConcurrency;
    await Future.wait<void>(
      List<Future<void>>.generate(workerCount, (_) => worker()),
    );
  }

  String _validatePathSegment(String value, String fieldName) {
    if (value.isEmpty ||
        value == "." ||
        value == ".." ||
        p.isAbsolute(value) ||
        p.basename(value) != value) {
      throw FormatException("Invalid hot-update $fieldName: $value");
    }
    return value;
  }

  String _validateRelativePath(String path) {
    if (path.isEmpty) {
      throw const FormatException("Hot-update file path cannot be empty");
    }

    final String normalized = p.normalize(path);
    final List<String> parts = p.split(normalized);
    if (p.isAbsolute(normalized) ||
        parts.isEmpty ||
        parts.first == ".." ||
        normalized == ".") {
      throw FormatException("Invalid hot-update file path: $path");
    }
    return normalized;
  }

  String? _validateSha256(String? value) {
    final String? normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    if (!_sha256Pattern.hasMatch(normalized)) {
      throw FormatException("Invalid SHA-256 value: $value");
    }
    return normalized.toLowerCase();
  }

  Future<void> _safeDeleteFile(String path) async {
    try {
      final File file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  Future<void> _safeDeleteDirectory(Directory directory) async {
    try {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    } catch (_) {}
  }

  static Future<T> _serialize<T>(Future<T> Function() action) {
    final Completer<T> completer = Completer<T>();
    final Future<void> previous = _updateTail;
    _updateTail = completer.future.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );

    unawaited(() async {
      await previous;
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    }());

    return completer.future;
  }
}

class _PreparedUpdate {
  final String id;
  final String versionId;
  final String rootPath;
  final List<_PreparedFile> files;

  const _PreparedUpdate({
    required this.id,
    required this.versionId,
    required this.rootPath,
    required this.files,
  });
}

class _PreparedFile {
  final String relativePath;
  final String downloadLink;
  final String? sha256;

  const _PreparedFile({
    required this.relativePath,
    required this.downloadLink,
    required this.sha256,
  });
}
