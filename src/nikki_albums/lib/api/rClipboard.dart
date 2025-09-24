import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

// 往剪贴板写入文字
void writeTextToClipboard(String text) {
  if (OpenClipboard(0) == 0) return;

  EmptyClipboard();
  final wideText = text.toNativeUtf16();
  final bufferSize = (text.length + 1) * sizeOf<Uint16>();
  final hGlobal = GlobalAlloc(GMEM_MOVEABLE | GMEM_ZEROINIT, bufferSize);

  if (hGlobal != 0) {
    // 明确指定指针类型为Pointer<Uint16>
    final lpstr = GlobalLock(hGlobal) as Pointer<Uint16>;
    if (lpstr != nullptr) {
      // 使用内存复制函数替代列表操作
      final sourcePtr = wideText.cast<Uint8>();
      final destPtr = lpstr.cast<Uint8>();
      for (var i = 0; i < bufferSize; i++) {
        destPtr[i] = sourcePtr[i];
      }

      GlobalUnlock(hGlobal);
      // 确保传递的是句柄（int类型）而非指针
      SetClipboardData(CF_UNICODETEXT, hGlobal as int);
    } else {
      GlobalFree(hGlobal);
    }
  }

  free(wideText);
  CloseClipboard();
}

// 复制多个文件到剪贴板
void copyFiles(List<String> filePaths) {
  _fileOperation(filePaths, FO_COPY);
}

// 剪切多个文件到剪贴板
void cutFiles(List<String> filePaths) {
  _fileOperation(filePaths, FO_MOVE);
}

// 执行文件操作（复制或剪切）
void _fileOperation(List<String> filePaths, int operation) {
  if (filePaths.isEmpty) return;

  final pathBuffer = StringBuffer();
  for (final path in filePaths) {
    pathBuffer.write('$path\0');
  }
  pathBuffer.write('\0');

  final pFrom = pathBuffer.toString().toNativeUtf16();
  final fileOp = calloc<SHFILEOPSTRUCT>()
    ..ref.wFunc = operation
    ..ref.pFrom = pFrom
    ..ref.pTo = nullptr
    ..ref.fFlags = FOF_ALLOWUNDO | FOF_NOCONFIRMMKDIR | FOF_SILENT;

  SHFileOperation(fileOp);

  free(pFrom);
  free(fileOp);
}
