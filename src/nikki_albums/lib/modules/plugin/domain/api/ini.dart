
import "package:nikki_albums/utils/ini.dart" as ini;


Map<String, dynamic> iniDecode(String content, [bool flatDefaultOption = true]){
  return ini.iniDecode(content, flatDefaultOption);
}

String iniEncode(Map<String, dynamic> content){
  return ini.iniEncode(content);
}