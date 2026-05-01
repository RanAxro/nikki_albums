// import 'dart:ffi';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:ffi/ffi.dart';
//
// // ============================================================
// // 动态库加载
// // ============================================================
//
// DynamicLibrary _loadLib() {
//   // if (Platform.isLinux) return DynamicLibrary.open('libdecrypt.so');
//   // if (Platform.isMacOS) return DynamicLibrary.open('libdecrypt.dylib');
//   if (Platform.isWindows) return DynamicLibrary.open('nuan5_decryption.dll');
//   // if (Platform.isAndroid) return DynamicLibrary.open('libdecrypt.so');
//   // if (Platform.isIOS) return DynamicLibrary.process();
//   throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
// }
//
// final _lib = _loadLib();
//
// // ============================================================
// // C 类型定义
// // ============================================================
//
// base class CDecryptionResult extends Struct {
//   @Uint32()
//   external int status;
//
//   external Pointer<Uint8> data;
//
//   @Size()
//   external int len;
// }
//
// base class CKey extends Opaque {}
//
// // ============================================================
// // FFI 函数绑定
// // ============================================================
//
// typedef _ProgressCallbackNative = Void Function(Size current, Size total);
//
// final _freeDecryptionResult = _lib.lookupFunction<
//     Void Function(CDecryptionResult result),
//     void Function(CDecryptionResult result)
// >('free_decryption_result');
//
// final _keyFromBytes = _lib.lookupFunction<
//     Pointer<CKey> Function(Pointer<Uint8> bytes, Size len),
//     Pointer<CKey> Function(Pointer<Uint8> bytes, int len)
// >('key_from_bytes');
//
// final _keyFromStrBytes = _lib.lookupFunction<
//     Pointer<CKey> Function(Pointer<Uint8> bytes, Size len),
//     Pointer<CKey> Function(Pointer<Uint8> bytes, int len)
// >('key_from_str_bytes');
//
// final _keyFromStr = _lib.lookupFunction<
//     Pointer<CKey> Function(Pointer<Char> s),
//     Pointer<CKey> Function(Pointer<Char> s)
// >('key_from_str');
//
// final _keyCameraParam = _lib.lookupFunction<
//     Pointer<CKey> Function(),
//     Pointer<CKey> Function()
// >('key_camera_param');
//
// final _freeKey = _lib.lookupFunction<
//     Void Function(Pointer<CKey> key),
//     void Function(Pointer<CKey> key)
// >('free_key');
//
// final _decrypt = _lib.lookupFunction<
//     CDecryptionResult Function(Pointer<Uint8> data, Size len, Pointer<CKey> key),
//     CDecryptionResult Function(Pointer<Uint8> data, int len, Pointer<CKey> key)
// >('decrypt');
//
// final _decodeFileBytesUnchecked = _lib.lookupFunction<
//     CDecryptionResult Function(Pointer<Uint8> flag, Size flagLen,
//         Pointer<Uint8> bytes, Size bytesLen, Pointer<CKey> key),
//     CDecryptionResult Function(Pointer<Uint8> flag, int flagLen,
//         Pointer<Uint8> bytes, int bytesLen, Pointer<CKey> key)
// >('decode_file_bytes_unchecked');
//
// final _decodeFileUnchecked = _lib.lookupFunction<
//     CDecryptionResult Function(Pointer<Uint8> flag, Size flagLen,
//         Pointer<Char> path, Pointer<CKey> key),
//     CDecryptionResult Function(Pointer<Uint8> flag, int flagLen,
//         Pointer<Char> path, Pointer<CKey> key)
// >('decode_file_unchecked');
//
// final _decodeFilesUnchecked = _lib.lookupFunction<
//     Pointer<CDecryptionResult> Function(Pointer<Uint8> flag, Size flagLen,
//         Pointer<Pointer<Char>> paths, Size pathCount, Pointer<CKey> key,
//         Pointer<NativeFunction<_ProgressCallbackNative>> callback),
//     Pointer<CDecryptionResult> Function(Pointer<Uint8> flag, int flagLen,
//         Pointer<Pointer<Char>> paths, int pathCount, Pointer<CKey> key,
//         Pointer<NativeFunction<_ProgressCallbackNative>> callback)
// >('decode_files_unchecked');
//
// final _freeResultsArray = _lib.lookupFunction<
//     Void Function(Pointer<CDecryptionResult> arr, Size count),
//     void Function(Pointer<CDecryptionResult> arr, int count)
// >('free_results_array');
//
// final _freeResultsArrayAndData = _lib.lookupFunction<
//     Void Function(Pointer<CDecryptionResult> arr, Size count),
//     void Function(Pointer<CDecryptionResult> arr, int count)
// >('free_results_array_and_data');
//
// // ============================================================
// // Dart 封装
// // ============================================================
//
// /// 解密状态码
// class DecryptionStatus {
//   static const success = 0;
//   static const dataLenIsNotAMultipleOf16 = 1;
//   static const decodingBase64Failed = 2;
//   static const findNoStartFlag = 3;
//   static const findNoEndFlag = 4;
//   static const io = 5;
//
//   static String message(int status) => switch (status) {
//     success => 'Success',
//     dataLenIsNotAMultipleOf16 => 'Data length is not a multiple of 16',
//     decodingBase64Failed => 'Decoding base64 failed',
//     findNoStartFlag => 'Find no start flag',
//     findNoEndFlag => 'Find no end flag',
//     io => 'IO error',
//     _ => 'Unknown error (status: $status)',
//   };
// }
//
// abstract class Param{
//   const Param();
// }
//
// /// 解密成功结果：包含数据
// class ValidParam extends Param{
//   final Uint8List data;
//   const ValidParam(this.data);
//
//   @override
//   String toString() => 'ValidParam(data.length=${data.length})';
// }
//
// /// 解密成功但无数据（空结果）
// class InvalidParam extends Param{
//   const InvalidParam();
//
//   @override
//   String toString() => 'InvalidParam()';
// }
//
// /// Key 封装类
// class Key {
//   Pointer<CKey> _ptr;
//   bool _disposed = false;
//
//   Key._(this._ptr);
//
//   /// 从原始字节创建 Key
//   factory Key.fromBytes(Uint8List bytes) {
//     final ptr = calloc<Uint8>(bytes.length);
//     try {
//       ptr.asTypedList(bytes.length).setAll(0, bytes);
//       final keyPtr = _keyFromBytes(ptr, bytes.length);
//       if (keyPtr == nullptr) {
//         throw StateError('key_from_bytes returned null');
//       }
//       return Key._(keyPtr);
//     } finally {
//       calloc.free(ptr);
//     }
//   }
//
//   /// 从字符串字节创建 Key
//   factory Key.fromStrBytes(Uint8List bytes) {
//     final ptr = calloc<Uint8>(bytes.length);
//     try {
//       ptr.asTypedList(bytes.length).setAll(0, bytes);
//       final keyPtr = _keyFromStrBytes(ptr, bytes.length);
//       if (keyPtr == nullptr) {
//         throw StateError('key_from_str_bytes returned null');
//       }
//       return Key._(keyPtr);
//     } finally {
//       calloc.free(ptr);
//     }
//   }
//
//   /// 从 UTF-8 字符串创建 Key
//   factory Key.fromString(String s) {
//     final ptr = s.toNativeUtf8();
//     try {
//       final keyPtr = _keyFromStr(ptr.cast<Char>());
//       if (keyPtr == nullptr) {
//         throw StateError('key_from_str returned null');
//       }
//       return Key._(keyPtr);
//     } finally {
//       calloc.free(ptr);
//     }
//   }
//
//   /// 创建固定密钥（camera_param）
//   factory Key.cameraParam() {
//     final keyPtr = _keyCameraParam();
//     if (keyPtr == nullptr) {
//       throw StateError('key_camera_param returned null');
//     }
//     return Key._(keyPtr);
//   }
//
//   Pointer<CKey> get ptr {
//     _ensureNotDisposed();
//     return _ptr;
//   }
//
//   bool get isDisposed => _disposed;
//
//   /// 释放 Key
//   void dispose() {
//     if (_disposed) return;
//     _freeKey(_ptr);
//     _disposed = true;
//   }
//
//   void _ensureNotDisposed() {
//     if (_disposed) throw StateError('Key has been disposed');
//   }
// }
//
// // ============================================================
// // 结果处理辅助函数
// // ============================================================
//
// /// 处理 C 返回的 DecryptionResult
// /// - status != 0: 失败，返回 null
// /// - status == 0 且 data == null/len == 0: 返回 InvalidParam
// /// - status == 0 且有数据: 拷贝到 Dart，释放 C 内存，返回 ValidParam
// Param? _handleResult(CDecryptionResult result) {
//   if (result.status != DecryptionStatus.success) {
//     // 失败：释放 C 侧 result 并返回 null
//     _freeDecryptionResult(result);
//     return null;
//   }
//
//   if (result.data == nullptr || result.len == 0) {
//     // 成功但无数据
//     _freeDecryptionResult(result);
//     return const InvalidParam();
//   }
//
//   // 成功且有数据：拷贝到 Dart
//   final dartData = Uint8List(result.len);
//   dartData.setAll(0, result.data.asTypedList(result.len));
//
//   // 释放 C 侧内存
//   _freeDecryptionResult(result);
//
//   return ValidParam(dartData);
// }
//
// // ============================================================
// // 解密函数封装
// // ============================================================
//
// /// 解密内存数据
// ///
// /// 返回 null 表示失败，ValidParam 表示成功且有数据，InvalidParam 表示成功但无数据
// Param? decryptData(Uint8List data, Key key) {
//   key._ensureNotDisposed();
//   final ptr = calloc<Uint8>(data.length);
//   try {
//     ptr.asTypedList(data.length).setAll(0, data);
//     final result = _decrypt(ptr, data.length, key.ptr);
//     return _handleResult(result);
//   } finally {
//     calloc.free(ptr);
//   }
// }
//
// /// 从文件字节中查找标志并解密
// ///
// /// [flag] 标志字节
// /// [bytes] 文件字节
// /// [key] 密钥
// Param? decodeFileBytes(Uint8List flag, Uint8List bytes, Key key) {
//   key._ensureNotDisposed();
//   final flagPtr = calloc<Uint8>(flag.length);
//   final bytesPtr = calloc<Uint8>(bytes.length);
//   try {
//     flagPtr.asTypedList(flag.length).setAll(0, flag);
//     bytesPtr.asTypedList(bytes.length).setAll(0, bytes);
//     final result = _decodeFileBytesUnchecked(
//       flagPtr, flag.length,
//       bytesPtr, bytes.length,
//       key.ptr,
//     );
//     return _handleResult(result);
//   } finally {
//     calloc.free(flagPtr);
//     calloc.free(bytesPtr);
//   }
// }
//
// /// 从文件路径解密
// ///
// /// [flag] 标志字节
// /// [path] 文件路径
// /// [key] 密钥
// Param? decodeFile(Uint8List flag, String path, Key key) {
//   key._ensureNotDisposed();
//   final flagPtr = calloc<Uint8>(flag.length);
//   final pathPtr = path.toNativeUtf8();
//   try {
//     flagPtr.asTypedList(flag.length).setAll(0, flag);
//     final result = _decodeFileUnchecked(
//       flagPtr, flag.length,
//       pathPtr.cast<Char>(),
//       key.ptr,
//     );
//     return _handleResult(result);
//   } finally {
//     calloc.free(flagPtr);
//     calloc.free(pathPtr);
//   }
// }
//
// /// 批量解密文件（带进度回调）
// ///
// /// [flag] 标志字节
// /// [paths] 文件路径列表
// /// [key] 密钥
// /// [onProgress] 进度回调（可选），参数为 (current, total)
// ///
// /// 返回与 [paths] 长度相同的列表，每个元素对应一个文件的解密结果。
// /// null 表示该文件解密失败，ValidParam 表示成功有数据，InvalidParam 表示成功但无数据。
// List<Param?> decodeFiles(
//     Uint8List flag,
//     List<String> paths,
//     Key key, {
//       void Function(int current, int total)? onProgress,
//     }) {
//   key._ensureNotDisposed();
//   if (paths.isEmpty) return [];
//
//   final flagPtr = calloc<Uint8>(flag.length);
//   final pathPtrs = calloc<Pointer<Char>>(paths.length);
//   final pathStrings = <Pointer<Utf8>>[];
//
//   NativeCallable<_ProgressCallbackNative>? callback;
//   Pointer<NativeFunction<_ProgressCallbackNative>>? callbackPtr;
//
//   try {
//     // 准备 flag
//     flagPtr.asTypedList(flag.length).setAll(0, flag);
//
//     // 准备路径字符串数组
//     for (int i = 0; i < paths.length; i++) {
//       final str = paths[i].toNativeUtf8();
//       pathStrings.add(str);
//       pathPtrs[i] = str.cast<Char>();
//     }
//
//     // 准备回调
//     if (onProgress != null) {
//       callback = NativeCallable<_ProgressCallbackNative>.listener(
//             (int current, int total) => onProgress(current, total),
//       );
//       callbackPtr = callback.nativeFunction;
//     }
//
//     // 调用 C 函数
//     final resultsPtr = _decodeFilesUnchecked(
//       flagPtr, flag.length,
//       pathPtrs, paths.length,
//       key.ptr,
//       callbackPtr ?? nullptr,
//     );
//
//     if (resultsPtr == nullptr) {
//       throw StateError('decode_files_unchecked returned null');
//     }
//
//     // 解析结果
//     final results = <Param?>[];
//     for (int i = 0; i < paths.length; i++) {
//       final result = resultsPtr.elementAt(i).ref;
//       results.add(_handleResult(result));
//     }
//
//     // 释放结果数组本身（data 已在 _handleResult 中释放）
//     _freeResultsArray(resultsPtr, paths.length);
//
//     return results;
//   } finally {
//     calloc.free(flagPtr);
//     calloc.free(pathPtrs);
//     for (final str in pathStrings) {
//       calloc.free(str);
//     }
//     callback?.close();
//   }
// }
//
// /// 批量解密文件，使用 C 侧便捷函数释放所有内存
// ///
// /// 注意：此函数不返回解密结果，适用于仅需要进度回调的场景。
// /// 如果需要获取解密数据，请使用 [decodeFiles]。
// void decodeFilesAndFreeAll(
//     Uint8List flag,
//     List<String> paths,
//     Key key, {
//       void Function(int current, int total)? onProgress,
//     }) {
//   key._ensureNotDisposed();
//   if (paths.isEmpty) return;
//
//   final flagPtr = calloc<Uint8>(flag.length);
//   final pathPtrs = calloc<Pointer<Char>>(paths.length);
//   final pathStrings = <Pointer<Utf8>>[];
//
//   NativeCallable<_ProgressCallbackNative>? callback;
//   Pointer<NativeFunction<_ProgressCallbackNative>>? callbackPtr;
//
//   try {
//     flagPtr.asTypedList(flag.length).setAll(0, flag);
//
//     for (int i = 0; i < paths.length; i++) {
//       final str = paths[i].toNativeUtf8();
//       pathStrings.add(str);
//       pathPtrs[i] = str.cast<Char>();
//     }
//
//     if (onProgress != null) {
//       callback = NativeCallable<_ProgressCallbackNative>.listener(
//             (int current, int total) => onProgress(current, total),
//       );
//       callbackPtr = callback.nativeFunction;
//     }
//
//     final resultsPtr = _decodeFilesUnchecked(
//       flagPtr, flag.length,
//       pathPtrs, paths.length,
//       key.ptr,
//       callbackPtr ?? nullptr,
//     );
//
//     if (resultsPtr == nullptr) return;
//
//     // 使用 C 侧便捷函数释放所有内存（包括 data）
//     _freeResultsArrayAndData(resultsPtr, paths.length);
//   } finally {
//     calloc.free(flagPtr);
//     calloc.free(pathPtrs);
//     for (final str in pathStrings) {
//       calloc.free(str);
//     }
//     callback?.close();
//   }
// }