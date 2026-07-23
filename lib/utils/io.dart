import "dart:io";
import "package:path/path.dart" as p;

Future<void> copyDirectory(String sourcePath, String destPath) async{
  final Directory sourceDir = Directory(sourcePath);
  final Directory destDir = Directory(destPath);

  if(!await destDir.exists()){
    await destDir.create(recursive: true);
  }

  await for(final FileSystemEntity entity in sourceDir.list(recursive: false)){
    final String newPath = p.join(destDir.path, p.basename(entity.path));

    if(entity is File){
      await entity.copy(newPath);
    }else if(entity is Directory){
      await copyDirectory(entity.path, newPath);
    }
  }
}