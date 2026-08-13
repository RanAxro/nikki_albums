import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

/// A utility class for file picking operations.
///
/// On macOS, this uses a custom native implementation that works better
/// with non-sandboxed applications. On other platforms, it falls back to
/// the standard file_picker package.
class NativeFilePicker {
  static const MethodChannel _channel =
      MethodChannel('com.ranaxro.nikki.nikkiAlbums/live_photo');

  /// Opens a directory picker dialog.
  ///
  /// Returns the selected directory path, or null if the user cancelled.
  static Future<String?> getDirectoryPath({
    required String dialogTitle,
    bool lockParentWindow = true,
  }) async {
    if (Platform.isMacOS) {
      return _getDirectoryPathMacOS(dialogTitle);
    } else {
      return FilePicker.platform.getDirectoryPath(
        dialogTitle: dialogTitle,
        lockParentWindow: lockParentWindow,
      );
    }
  }

  /// Opens a save file dialog.
  ///
  /// Returns the selected file path, or null if the user cancelled.
  static Future<String?> saveFile({
    required String dialogTitle,
    required String fileName,
    bool lockParentWindow = true,
  }) async {
    if (Platform.isMacOS) {
      return _saveFileMacOS(dialogTitle, fileName);
    } else {
      return FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        lockParentWindow: lockParentWindow,
      );
    }
  }

  /// macOS-specific directory picker using native NSOpenPanel.
  static Future<String?> _getDirectoryPathMacOS(String dialogTitle) async {    try {
      final String? result = await _channel.invokeMethod<String>(
        'getDirectoryPath',
        {'dialogTitle': dialogTitle},
      );
      return result;
    } on PlatformException catch (e) {
      print('Failed to get directory path: ${e.message}');
      return null;
    }
  }

  /// macOS-specific save file dialog using native NSSavePanel.
  static Future<String?> _saveFileMacOS(
      String dialogTitle, String fileName) async {
    try {
      final String? result = await _channel.invokeMethod<String>(
        'saveFile',
        {
          'dialogTitle': dialogTitle,
          'fileName': fileName,
        },
      );
      return result;
    } on PlatformException catch (e) {
      print('Failed to save file: ${e.message}');
      return null;
    }
  }

  /// Opens a file picker dialog for selecting files.
  ///
  /// This always uses the standard file_picker implementation.
  static Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    bool allowMultiple = false,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    FileType type = FileType.any,
    bool lockParentWindow = false,
    String? initialDirectory,
    bool withData = true,
    bool withReadStream = false,
  }) async {
    return FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      type: type,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
      withData: withData,
      withReadStream: withReadStream,
    );
  }
}
