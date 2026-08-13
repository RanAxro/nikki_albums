
export "package:nikki_albums/src/rust/config/common/string_config.dart";

import "package:nikki_albums/src/rust/config/common/string_config.dart";


abstract final class StringConfigHelper{
  static final RegExp _varReg = RegExp(r'\$([^$]*)\$');
  static final RegExp _groupReg = RegExp(r'\$(\d+)\$');

  static String resolveByConfig(String raw, StringConfig config, [Map<String, String>? varMap]){
    return resolveByProcess(raw, config.process, varMap);
  }

  static String resolveByProcess(String raw, List<StringProcessConfig> processes, [Map<String, String>? varMap]){
    String s = raw;
    for(final StringProcessConfig process in processes){
      s = switch(process){
        StringProcessConfig_Join(field0: final joinProcess) => resolveByJoinProcess(s, joinProcess),
        StringProcessConfig_Match(field0: final matchProcess) => resolveByMatchProcess(s, matchProcess),
        StringProcessConfig_Replace(field0: final replaceProcess) => resolveByReplaceProcess(s, replaceProcess),
        StringProcessConfig_ReplaceAll(field0: final replaceAllProcess) => resolveByReplaceAllProcess(s, replaceAllProcess),
      };
    }

    if(varMap == null || varMap.isEmpty){
      return s;
    }
    return s.replaceAllMapped(_varReg, (Match match){
      final String targetVar = match.group(1)!;
      return varMap[targetVar] ?? targetVar;
    });
  }

  static String resolveByJoinProcess(String raw, StringJoinProcessConfig joinProcess){
    return joinProcess.target.map((List<StringProcessConfig> process){
      return resolveByProcess(raw, process);
    }).join(joinProcess.separator);
  }

  static String resolveByMatchProcess(String raw, StringMatchProcessConfig matchProcess){
    try{
      final RegExp regex = RegExp(matchProcess.regex);

      final Iterable<RegExpMatch> all = regex.allMatches(raw);

      if(matchProcess.which < 1 || all.length < matchProcess.which){
        throw 0;
      }
      final RegExpMatch targetMatch = all.elementAt(matchProcess.which - 1);

      return matchProcess.successful.replaceAllMapped(_groupReg, (Match match){
        final int group = int.parse(match.group(1)!);
        return targetMatch.group(group)!;
      });
    }catch(e){
      return resolveByProcess(raw, matchProcess.failed);
    }
  }

  static String resolveByReplaceProcess(String raw, StringReplaceProcessConfig replaceProcess){
    final RegExp regex = RegExp(replaceProcess.regex);

    return raw.replaceFirstMapped(regex, (Match match){
      return replaceProcess.to.replaceAllMapped(_groupReg, (Match match){
        final int group = int.parse(match.group(1)!);
        return match.group(group)!;
      });
    }, replaceProcess.which - 1);
  }

  static String resolveByReplaceAllProcess(String raw, StringReplaceAllProcessConfig replaceAllProcess){
    final RegExp regex = RegExp(replaceAllProcess.regex);

    return raw.replaceAllMapped(regex, (Match match){
      return replaceAllProcess.to.replaceAllMapped(_groupReg, (Match match){
        final int group = int.parse(match.group(1)!);
        return match.group(group)!;
      });
    });
  }
}