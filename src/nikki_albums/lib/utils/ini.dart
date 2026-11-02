
import "package:ini/ini.dart";


Map<String, dynamic> iniDecode(String content, [bool flatDefaultOption = true]){
  final Config config = Config.fromString(content);
  final Map<String, dynamic> res = {};

  if(flatDefaultOption){
    res.addAll(config.defaults());
  }else{
    res[""] = config.defaults();
  }

  for(final String section in config.sections()){
    final List<List<String?>> entries = config.items(section) ?? const [];
    res[section] = Map.fromIterables(entries.map((o) => o[0]), entries.map((o) => o[1]));
  }

  return res;
}

String iniEncode(Map<String, dynamic> content){
  final Config config = Config();

  for(final MapEntry<String, dynamic> entries in content.entries){
    if(entries.value is Map){
      final String section = entries.key;
      if(!config.hasSection(section)){
        config.addSection(section);
      }
      for(final MapEntry optionEntries in entries.value){
        config.set(section, optionEntries.key.toString(), optionEntries.value.toString());
      }
    }else{
      config.set("default", entries.key.toString(), entries.value.toString());
    }
  }

  return config.toString();
}