
import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:crypto/crypto.dart";
import "package:encrypt/encrypt.dart";



enum GameImageCodecException{
  lackFFD9,
  notJson,
}

abstract class GameImageCodec{}




abstract class GameJsonCodec{
  static String encode(dynamic source, {bool standard = false, int spaceNum = 2, bool expandEmptyObject = false}) =>
    spaceNum <= 0 ?
      _encode(source, standard) :
      _formatEncode(source, standard, spaceNum, expandEmptyObject, 0);

  static String _encodeString(String input){
    final StringBuffer buffer = StringBuffer('"');

    for(final rune in input.runes){
      switch(rune){
        case 0x22: buffer.write(r'\"'); break;
        case 0x5C: buffer.write(r"\\"); break;
        case 0x08: buffer.write(r"\b"); break;
        case 0x0C: buffer.write(r"\f"); break;
        case 0x0A: buffer.write(r"\n"); break;
        case 0x0D: buffer.write(r"\r"); break;
        case 0x09: buffer.write(r"\t"); break;
        default:
          if(rune < 0x20){
            buffer.write("\\u${rune.toRadixString(16).padLeft(4, "0")}");
          }else{
            buffer.write(String.fromCharCode(rune));
          }
      }
    }

    buffer.write('"');
    return buffer.toString();
  }

  static String _encode(dynamic source, bool standard){
    switch(source){
      case int() || double() || bool() || null:
        return source.toString();
      case String():
        return _encodeString(source);
      case Iterable():
        return "[${source.map((value) => _encode(value, standard)).join(",")}]";
      case Map():
        bool allKeyIsString = !source.keys.any((key) => key is! String);
        if(allKeyIsString || standard){
          return "{${source.entries.map((entry) => "${_encodeString(entry.key.toString())}:${_encode(entry.value, standard)}").join(",")}}";
        }else{
          return "[${source.entries.map((entry) => ":${_encode(entry.key, standard)}:${_encode(entry.value, standard)}").join(",")}]";
        }
      default:
        return _encodeString(source.toString());
    }
  }

  static String _formatEncode(dynamic source, bool standard, int spaceNum, bool expandEmptyObject, int level){
    final String space = " " * spaceNum * level;
    final String nextSpace = " " * spaceNum * (level + 1);
    switch(source){
      case int() || double() || bool() || null:
        return source.toString();
      case String():
        return _encodeString(source);
      case Iterable():
        if(source.isEmpty && !expandEmptyObject) return "[]";
        return "[\n$nextSpace${source.map((value) => _formatEncode(value, standard, spaceNum, expandEmptyObject, level + 1)).join(",\n$nextSpace")}\n$space]";
      case Map():
        if(source.isEmpty && !expandEmptyObject) return "{}";
        bool allKeyIsString = !source.keys.any((key) => key is! String);
        if(allKeyIsString || standard){
          return "{\n$nextSpace${source.entries.map((entry) => "${_encodeString(entry.key.toString())}: ${_formatEncode(entry.value, standard, spaceNum, expandEmptyObject, level + 1)}").join(",\n$nextSpace")}\n$space}";
        }else{
          return "[\n$nextSpace${source.entries.map((entry) => ":${_formatEncode(entry.key, standard, spaceNum, expandEmptyObject, level + 1)}:${_formatEncode(entry.value, standard, spaceNum, expandEmptyObject, level + 1)}").join(",\n$nextSpace")}\n$space]";
        }
      default:
        return _encodeString(source.toString());
    }
  }


  static dynamic decode(String source){
    source = source.trim();
    if(source == "null") return null;
    if(source == "true") return true;
    if(source == "false") return false;
    if(source.startsWith('"')) return _decodeString(source);
    if(source.startsWith("[")){
      // 跳过 [ 后的空白，检查是否是 : 开头的非字符串键Map
      int i = 1;
      while(i < source.length && _isWhitespace(source[i])){
        i++;
      }
      return source[i] == ":" ? _decodeSpecialMap(source) : _decodeList(source);
    }
    if(source.startsWith("{")) return _decodeMap(source);
    return int.tryParse(source) ?? double.tryParse(source);
  }

  static bool _isWhitespace(String c) => c == " " || c == "\t" || c == "\n" || c == "\r";

  static String _decodeString(String s){
    final StringBuffer buffer = StringBuffer();
    for(int i = 1; i < s.length - 1; i++){
      if(s[i] == r"\" && i + 1 < s.length - 1){
        const m = {'"': '"', '\\': '\\', '/': '/', 'b': '\b', 'f': '\f', 'n': '\n', 'r': '\r', 't': '\t'};
        if(m.containsKey(s[i + 1])){
          buffer.write(m[s[++i]]);
          continue;
        }
        if(s[i + 1] == "u" && i + 5 < s.length - 1){
          final int? code = int.tryParse(s.substring(i + 2, i + 6), radix: 16);
          if(code != null){
            buffer.write(String.fromCharCode(code));
            i += 5;
            continue;
          }
        }
      }
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  static List<String> _split(String s){
    final r = <String>[];
    int d = 0, j = 0;
    bool q = false, e = false;
    for(var i = 0; i < s.length; i++){
      if(e){e = false; continue;}
      if(s[i] == "\\"){e = true; continue;}
      if(s[i] == '"'){q = !q; continue;}
      if(q) continue;
      if(s[i] == "[" || s[i] == "{") d++;
      if(s[i] == "]" || s[i] == "}") d--;
      if(s[i] == "," && d == 0){r.add(s.substring(j, i).trim()); j = i + 1;}
    }
    r.add(s.substring(j).trim());
    return r.where((x) => x.isNotEmpty).toList();
  }

  static List<dynamic> _decodeList(String s) => _split(s.substring(1, s.length - 1)).map(decode).toList();

  static Map<String, dynamic> _decodeMap(String s){
    final m = <String, dynamic>{};
    for(final e in _split(s.substring(1, s.length - 1))){
      final c = _findTopLevelColon(e);
      m[decode(e.substring(0, c).trim()) as String] = decode(e.substring(c + 1).trim());
    }
    return m;
  }

  static Map<dynamic, dynamic> _decodeSpecialMap(String s){
    final m = <dynamic, dynamic>{};
    // 提取 [ 和 ] 之间的内容
    final inner = s.substring(1, s.length - 1);
    for(final e in _split(inner)){
      var t = e.trim();
      // 跳过开头的 : 及其后的空白
      if(!t.startsWith(":")) continue;
      var i = 1;
      while(i < t.length && _isWhitespace(t[i])) i++;
      t = t.substring(i);

      final c = _findTopLevelColon(t);
      if(c == -1) continue;
      m[decode(t.substring(0, c).trim())] = decode(t.substring(c + 1).trim());
    }
    return m;
  }

  static int _findTopLevelColon(String s){
    int d = 0;
    bool q = false, e = false;
    for(var i = 0; i < s.length; i++){
      if(e){e = false; continue;}
      if(s[i] == "\\"){e = true; continue;}
      if(s[i] == '"'){q = !q; continue;}
      if(q) continue;
      if(s[i] == "[" || s[i] == "{") d++;
      if(s[i] == "]" || s[i] == "}") d--;
      if(s[i] == ":" && d == 0) return i;
    }
    return -1;
  }
}





abstract class GameCameraParamCodec{
  static void decode(String data){

  }
}










