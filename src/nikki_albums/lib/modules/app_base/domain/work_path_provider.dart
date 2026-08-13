
import "dart:io";

import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as p;


Future<String> getAppDataDirectoryPath([bool create = false]) async{
  final Directory directory = await getApplicationDocumentsDirectory();

  final String appDataDirectoryPath = p.join(directory.path, "Nikki Albums");

  if(create){
    final Directory appDataDirectory = Directory(appDataDirectoryPath);
    if(!await appDataDirectory.exists()){
      appDataDirectory.create(recursive: true);
    }
  }

  return appDataDirectoryPath;
}


Future<String> getAppConfigFilePath([bool create = false]) async{
  final String appDataDirectoryPath = await getAppDataDirectoryPath(create);

  final String configFilePath = p.join(appDataDirectoryPath, "config3.json");

  if(create){
    final File configFile = File(configFilePath);
    if(!await configFile.exists()){
      configFile.create(recursive: true);
    }
  }

  return configFilePath;
}





