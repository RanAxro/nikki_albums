
import "package:path/path.dart" as p;


final String separator = p.separator;

String join(Iterable<String> parts){
  return p.joinAll(parts);
}

String basename(String path){
  return p.basename(path);
}

String basenameWithoutExtension(String path){
  return p.basenameWithoutExtension(path);
}

String dirname(String path){
  return p.dirname(path);
}

String extension(String path, [int level = 1]){
  return p.extension(path, level);
}

String rootPrefix(String path){
  return p.rootPrefix(path);
}

bool isAbsolute(String path){
  return p.isAbsolute(path);
}

bool isRelative(String path){
  return p.isRelative(path);
}

bool isRootRelative(String path){
  return p.isRootRelative(path);
}

List<String> split(String path){
  return p.split(path);
}

String canonicalize(String path){
  return p.canonicalize(path);
}

String normalize(String path){
  return p.normalize(path);
}

bool isWithin(String parent, String child){
  return isWithin(parent, child);
}

bool equals(String path1, String path2){
  return p.equals(path1, path2);
}

String withoutExtension(String path){
  return p.withoutExtension(path);
}

String setExtension(String path, String extension){
  return p.setExtension(path, extension);
}

String fromUri(String uri){
  return p.fromUri(uri);
}

String toUri(String path){
  return p.toUri(path).toString();
}