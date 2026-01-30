export "windows.dart";
export "android.dart";


import "dart:io";

import "package:nikkialbums/utils/system/windows.dart";

import "../path.dart";


import "package:path_provider/path_provider.dart";



Future<Path> getAppDataDirectoryPath() async{
  final Directory directory = await getApplicationDocumentsDirectory();

  final Path appDataDirectoryPath = Path(directory.path) + "Nikki Albums";

  if(! await appDataDirectoryPath.directory.exists()) appDataDirectoryPath.directory.create(recursive: true);

  return appDataDirectoryPath;
}


Future<Path> getTempPath() async{
  final Path appDataDirectoryPath = await getAppDataDirectoryPath();

  final Path tempDirectoryPath = appDataDirectoryPath + "temp";

  if(! await tempDirectoryPath.directory.exists()) tempDirectoryPath.directory.create(recursive: true);

  return tempDirectoryPath;
}


Path getBinPath(){
  return Path(Platform.resolvedExecutable).cut(1) + "/data/flutter_assets/bin";
}

Path getWebPath(){
  return Path(Platform.resolvedExecutable).cut(1) + "/data/flutter_assets/assets/web";
}


Future<void> compress(List<Path> paths, Path to, [void Function(double)? onProcess]) async{
  if(Platform.isWindows){
    await compressInWindows(paths, to, onProcess);
  }else if(Platform.isAndroid){

  }else{

  }
}

Future<void> decompress(Path zipPath, Path to, [void Function(double)? onProcess]) async{
  if(Platform.isWindows){
    await decompressInWindows(zipPath, to);
    onProcess?.call(1);
  }else if(Platform.isAndroid){

  }else{

  }
}