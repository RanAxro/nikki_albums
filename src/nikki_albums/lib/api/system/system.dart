export "windows.dart";


import "dart:io";

import "windows.dart";
import "package:nikkialbums/api/path.dart";


import "package:path_provider/path_provider.dart";



Future<Path> getAppDateDirectoryPath() async{
  final Directory directory = await getApplicationDocumentsDirectory();

  final Path appDataDirectoryPath = Path(directory.path) + "Nikki Albums";

  if(! await appDataDirectoryPath.directory.exists()) appDataDirectoryPath.directory.create(recursive: true);

  return appDataDirectoryPath;
}


Future<Path> getTempPath() async{
  final Path appDataDirectoryPath = await getAppDateDirectoryPath();

  final Path tempDirectoryPath = appDataDirectoryPath + "temp";

  if(! await tempDirectoryPath.directory.exists()) tempDirectoryPath.directory.create(recursive: true);

  return tempDirectoryPath;
}


Path getBin(){
  return Path(Platform.resolvedExecutable).cut(1) + "/data/flutter_assets/bin";
}