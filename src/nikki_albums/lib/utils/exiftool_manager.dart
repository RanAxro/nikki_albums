import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExifToolManager {
  static Future<String> get _exifToolPath async {
    final bundledPath = p.join(
      p.dirname(Platform.resolvedExecutable),
      'bin',
      'exiftool.exe',
    );
    if (await File(bundledPath).exists()) {
      return bundledPath;
    }

    final appSupport = await getApplicationSupportDirectory();
    final path = p.join(appSupport.path, 'bin', 'exiftool.exe');
    return path;
  }

  static Future<bool> ensureInstalled() async {
    if (!Platform.isWindows) return false;
    final path = await _exifToolPath;
    return await File(path).exists();
  }

  static const String _appleTemplateBase64 =
      "/9j/4AAQSkZJRgABAQEASABIAAD/4QDeRXhpZgAATU0AKgAAAAgABQEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAAITAAMAAAABAAEAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAASQAAAHAAAABDAyMzKRAQAHAAAABAECAwCSfAAHAAAARgAAAJCgAQADAAAAAf//AAAAAAAAQXBwbGUgaU9TAAABTU0AAQARAAIAAAAlAAAAIAAAAABFRTg2QjI2My0zMzRGLTRBNzctOEFBOC1BOUQ0RjgzRjJDMzIAAP/bAEMA///////////////////////////////////////////////////////////////////////////////////////CAAsIAAEAAQEBEQD/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/9oACAEBAAE/EA==";

  static Future<void> writeLivePhotoIdentifier(
    String imagePath,
    String videoPath,
    String identifier,
  ) async {
    if (!await ensureInstalled())
      throw Exception("ExifTool is not installed or bundled path is missing.");
    try {
      final exe = await _exifToolPath;

      // 1. Prepare template file
      final appSupport = await getApplicationSupportDirectory();
      final templateFile = File(p.join(appSupport.path, 'apple_template.jpg'));
      if (!await templateFile.exists()) {
        await templateFile.writeAsBytes(
          const Base64Decoder().convert(_appleTemplateBase64),
        );
      }

      // 2. Graft MakerNotes from template to the target JPEG
      final graftArgs = [
        '-TagsFromFile',
        templateFile.path,
        '-MakerNotes',
        '-overwrite_original',
        imagePath,
      ];
      final graftResult = await Process.run(exe, graftArgs);
      if (graftResult.exitCode != 0) {
        throw Exception(
          "ExifTool template graft failed. stderr: ${graftResult.stderr}",
        );
      }

      // 3. Inject the specific UUIDs into both files
      final args = [
        '-overwrite_original',
        '-ContentIdentifier=$identifier',
        '-Keys:ContentIdentifier=$identifier',
        imagePath,
        videoPath,
      ];
      final result = await Process.run(exe, args);
      if (result.exitCode != 0) {
        throw Exception(
          "ExifTool returned exit code ${result.exitCode}. stderr: ${result.stderr}",
        );
      }
    } catch (e) {
      debugPrint("ExifTool write failed: $e");
      rethrow;
    }
  }
}
