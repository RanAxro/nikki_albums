import "../path.dart";

import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "dart:io";

import "package:saf/saf.dart";



Future<Path?> getAndroidDataDir(Path package, [int type = 2]) async{
  if(type == 1){

  }else if(type == 2){
    final Directory? filesDir = await getExternalStorageDirectory();

    if(filesDir == null) return null;

    return Path(filesDir.path).cut(2) + package;
  }
  return null;
}

Future<bool> requestAllFilesAccess() async{

  // var status = await Permission.storage.status;
  // if(!status.isGranted){
  //   await Permission.storage.request();
  //
  // }
  // await openAppSettings();

  if(await Permission.manageExternalStorage.isGranted){
    return true;
  }
  // 申请一次，Android 11+ 会自动拒绝并返回“永久拒绝”
  final status = await Permission.manageExternalStorage.request();
  if(status.isGranted){
    return true;
  }
  // 用户点了“拒绝”或“永久拒绝”→ 带他去系统设置页手动开
  await openAppSettings();
  return false;
}




Future te() async{

  Saf saf = Saf(r"content://com.android.externalstorage.documents/tree/primary%3AA%E2%80%8Bndroid%2Fdata/document/primary%3AA%E2%80%8Bndroid%2Fdata%2Fcom.papegames.infinitynikki");
  // Saf saf = Saf(r"/storage/emulated/0/Android/data/com.papegames.infinitynikki/files/");

  bool? isGranted = await saf.getDirectoryPermission(isDynamic: false);

  if (isGranted != null && isGranted) {
    print("suc");
  } else {
    // failed to get the permission
    print("null");
  }

}
