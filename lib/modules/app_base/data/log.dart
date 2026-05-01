

abstract class AppLog{
  static Future<void> write(String form, String error) async{
    // try {
    //   final Path log = (await getAppDataDirectoryPath()) + "log.txt";
    //   if (!await log.file.exists()) {
    //     log.file.create(recursive: true);
    //   }
    //   log.file.writeAsString(
    //     "\n$form : $error",
    //     mode: FileMode.append,
    //     flush: true,
    //   );
    // } on FileSystemException catch (e) {
    //   final errno = e.osError?.errorCode;
    //   switch (errno) {
    //     case 13:
    //       print("权限被拒（Android 6+ 没动态申请存储权限，或 iOS 沙盒外路径）");
    //       break;
    //     case 28:
    //       print("磁盘已满");
    //       break;
    //     case 16 || 32:
    //       print("进程被占用");
    //       break;
    //   }
    // } catch (e) {
    //   print("写入失败: $e");
    // }
  }
}