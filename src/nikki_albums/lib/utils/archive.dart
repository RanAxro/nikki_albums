import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import "package:nikkialbums/utils/path.dart";

import 'package:archive/archive_io.dart';



List<List<T>> splitEvenly<T>(List<T> src, int n){
  if(n <= 0) throw ArgumentError("n must be > 0");
  if(src.isEmpty) return List.generate(n, (_) => <T>[]);

  final total = src.length;
  final base = total ~/ n;
  final rem = total % n;

  final result = <List<T>>[];
  int start = 0;
  for(int i = 0; i < n; i++){
    final extra = i < rem ? 1 : 0;
    final end = start + base + extra;
    result.add(src.sublist(start, end));
    start = end;
  }
  return result;
}

/// zip
Future<void> compressZip(List<File> files, List<Path> archiveFilePaths, File to, [void Function(double)? onProcess]) async{
  try{
    if(await to.exists()) await to.delete();

    files.removeWhere((File file) => !file.existsSync());

    final int total = files.length;
    int current = 0;
    int lastSize = 0;

    final ZipEncoder encoder = ZipEncoder();

    final Archive archive = Archive();

    final OutputFileStream outputStream = OutputFileStream(to.path);

    for(int i = 0; i < files.length; i++){
      final InputFileStream inputStream = InputFileStream(files[i].path);

      final ArchiveFile archiveFile = ArchiveFile.stream(archiveFilePaths[i].path, inputStream);
      /// keep Original
      archiveFile.lastModTime = files[i].lastModifiedSync().millisecondsSinceEpoch ~/ 1000;

      archive.addFile(archiveFile);
    }

    encoder.encodeStream(archive, outputStream, autoClose: true, level: DeflateLevel.none, callback: (ArchiveFile archiveFile) async{
      current += lastSize;
      lastSize = 1;
      onProcess?.call((current / total).clamp(0, 1));
    });

    await outputStream.close();
    onProcess?.call(1);
  }catch(e){
    onProcess?.call(1);
    rethrow;
  }
}

Future<void> compressZipIo(List<File> files, List<Path> archiveFilePaths, File to, [void Function(double)? onProcess]) async{
  final ReceivePort receivePort = ReceivePort();

  final isolate = await Isolate.spawn(_compressZipIsolate, [receivePort.sendPort, files.map((File file) => file.path).toList(), archiveFilePaths.map((Path path) => path.path).toList(), to.path]);

  await for(final message in receivePort){
    onProcess?.call(message);

    if(message == 1){
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  }
}

// [SendPort sendPort, List<String> files, List<String> archiveFilePaths, String to]
Future<void> _compressZipIsolate(List message) async{
  final SendPort sendPort = message[0];
  final List<File> files = (message[1] as List<String>).map((String path) => File(path)).toList();
  final List<Path> archiveFilePaths = (message[2] as List<String>).map((String path) => Path(path)).toList();
  final File to = File(message[3]);

  compressZip(files, archiveFilePaths, to, (double progress) => sendPort.send(progress));
}

Future<void> compressZipIoX(List<File> files, List<Path> archiveFilePaths, File to, {int core = 6, void Function(double)? onProcess}) async{
  if(core <= 0) core = Platform.numberOfProcessors - 1;
  if(core > files.length) core = files.length;

  final Completer completer = Completer();

  final List<List<File>> filesSplit = splitEvenly<File>(files, core);
  final List<List<Path>> archiveFilePathsSplit = splitEvenly<Path>(archiveFilePaths, core);
  final List<File> zipsSplit = [];

  final List<double> process = List.filled(core, 0);

  for(int i = 0; i < filesSplit.length; i++){
    final File singleZip = File(to.path + i.toString());
    zipsSplit.add(singleZip);

    compressZipIo(filesSplit[i], archiveFilePathsSplit[i], singleZip, (double theIoProgress){
      process[i] = theIoProgress;
      final double compressProgress = process.reduce((a, b) => a + b) / process.length;
      onProcess?.call(compressProgress * 0.5);

      /// finish compress
      if(compressProgress == 1){
        mergeZipArchiveIo(zipsSplit, to, (double mergeProgress){
          onProcess?.call(0.5 + mergeProgress * 0.5);

          if(mergeProgress == 1) completer.complete();
        });
      }
    });
  }

  return completer.future;
}


DateTime _getLastModDateTime(int lastModTime){
  final year = ((lastModTime >> 25) & 0x7f) + 1980;
  final month = ((lastModTime >> 21) & 0x0f);
  final day = (lastModTime >> 16) & 0x1f;
  final hours = (lastModTime >> 11) & 0x1f;
  final minutes = (lastModTime >> 5) & 0x3f;
  final seconds = (lastModTime << 1) & 0x3e;

  return DateTime(year, month, day, hours, minutes, seconds);
}
Future<void> mergeZipArchive(List<File> zipsSplit, File to, [void Function(double)? onProcess]) async{
  final Archive saveArchive = Archive();
  final ZipDecoder decoder = ZipDecoder();
  final ZipEncoder encoder = ZipEncoder();
  final OutputFileStream outputStream = OutputFileStream(to.path);

  for(int i = 0; i < zipsSplit.length; i++){
    final InputFileStream inputStream = InputFileStream(zipsSplit[i].path);
    final Archive archive = decoder.decodeStream(inputStream);

    for(final ArchiveFile archiveFile in archive){
      saveArchive.add(archiveFile);
    }
  }

  final int total = saveArchive.length;
  int current = 0;
  int lastSize = 0;

  encoder.encodeStream(saveArchive, outputStream, level: DeflateLevel.none, autoClose: true, callback: (ArchiveFile archiveFile){
    /// archive: ^4.0.7
    /// 文件解压后的 lastModTime 时间戳格式是 FAT 格式
    /// 文件解压后的 lastModDateTime 格式是 Unix 格式
    /// 压缩文件时 lastModTime 时间戳格式应为 Unix 格式
    /// FAT 时间戳以本地时间存储, 而非 UTC, 不能直接使用 archiveFile.lastModDateTime
    archiveFile.lastModTime = _getLastModDateTime(archiveFile.lastModTime).millisecondsSinceEpoch ~/ 1000;

    current += lastSize;
    lastSize = 1;
    onProcess?.call((current / total).clamp(0, 1));
  });

  await outputStream.close();
  for(final File singleZip in zipsSplit){
    singleZip.delete();
  }
  onProcess?.call(1);
}

Future<void> mergeZipArchiveIo(List<File> zipsSplit, File to, [void Function(double)? onProcess]) async{
  final ReceivePort receivePort = ReceivePort();

  final isolate = await Isolate.spawn(_mergeZipArchiveIsolate, [receivePort.sendPort, zipsSplit.map((File singleZip) => singleZip.path).toList(), to.path]);

  await for(final message in receivePort){
    onProcess?.call(message);

    if(message == 1){
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  }
}

// [SendPort sendPort, List<String> zipSplit, String to]
Future<void> _mergeZipArchiveIsolate(List message) async{
  final SendPort sendPort = message[0];
  final List<File> zipsSplit = (message[1] as List<String>).map((String path) => File(path)).toList();
  final File to = File(message[2]);

  mergeZipArchive(zipsSplit, to, (double progress) => sendPort.send(progress));
}



Future<void> decompressZip(File zip, Directory to, [void Function(double)? onProcess]) async{
  final Map<String, DateTime> files = {};

  try{
    final int total = await zip.length();
    int current = 0;
    int lastFileSize = 0;

    final InputFileStream inputStream = InputFileStream(zip.path);
    final Archive archive = ZipDecoder().decodeStream(
      inputStream,
      callback: (ArchiveFile archiveFile){
        if(archiveFile.isFile) files[archiveFile.name] = archiveFile.lastModDateTime;

        current += lastFileSize;
        lastFileSize = archiveFile.size;
        onProcess?.call((current / total).clamp(0, 1));
      }
    );
    await extractArchiveToDisk(archive, to.path);

    for(final MapEntry<String, DateTime> file in files.entries){
      await (Path(to.path) + file.key).file.setLastModified(file.value);
    }

    onProcess?.call(1);
  }catch(e){
    onProcess?.call(1);
    rethrow;
  }
}

Future<void> decompressZipIo(File zip, Directory to, [void Function(double)? onProcess]) async{
  final ReceivePort receivePort = ReceivePort();

  final isolate = await Isolate.spawn(_decompressIsolate, [receivePort.sendPort, zip.path, to.path]);

  await for(final message in receivePort){
    onProcess?.call(message);

    if(message == 1){
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  }
}

// [SendPort sendPort, String zip, String to]
Future<void> _decompressIsolate(List message) async{
  final SendPort sendPort = message[0];
  final File zip = File(message[1]);
  final Directory to = Directory(message[2]);

  decompressZip(zip, to, (double progress) => sendPort.send(progress));

  // try{
  //   final int total = await zip.length();
  //   int current = 0;
  //   int lastFileSize = 0;
  //
  //   final InputFileStream inputStream = InputFileStream(zip.path);
  //   final Archive archive = ZipDecoder().decodeStream(
  //     inputStream,
  //     callback: (ArchiveFile archiveFile){
  //       current += lastFileSize;
  //       lastFileSize = archiveFile.size;
  //       sendPort.send((current / total).clamp(0, 1));
  //     }
  //   );
  //   await extractArchiveToDisk(archive, to.path);
  //   sendPort.send(1);
  // }catch(e){
  //   sendPort.send(1);
  //   rethrow;
  // }
}









