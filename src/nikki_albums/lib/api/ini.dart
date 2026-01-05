/// 把 ini 文件内容解析成 Map
Map<String, Map<String, String>> parseIni(String content){
  final result = <String, Map<String, String>>{};
  String? curSection;
  for(var raw in content.split("\n")){
    final line = raw.trim();
    if(line.isEmpty || line.startsWith(RegExp(r"[;#]"))) continue;
    if(line.startsWith("[") && line.endsWith("]")){
      curSection = line.substring(1, line.length - 1).trim();
      result.putIfAbsent(curSection, () => {});
      continue;
    }
    final idx = line.indexOf("=");
    if(idx == -1 || curSection == null) continue;
    final key = line.substring(0, idx).trim();
    final value = line.substring(idx + 1).trim();
    result[curSection]![key] = value;
  }
  return result;
}