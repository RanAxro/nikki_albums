
import "package:nikki_albums/src/rust/config/common/string_config.dart";


abstract final class StringConfigProcessor{
  static final RegExp _varReg = RegExp(r'\$([^$]*)\$');
  static final RegExp _groupReg = RegExp(r'\$(\d+)\$');

  String withConfig(StringConfig config, String raw, [Map<String, String>? varMap]){
    return withProcess(config.process, raw, varMap);
  }

  String withProcess(List<StringProcessConfig> process, String raw, [Map<String, String>? varMap]){
    String s = raw;
    for(final StringProcessConfig p in process){
      p.when(
        join: (StringJoinProcessConfig joinProcess){
          s = withJoinProcess(joinProcess, s);
        },
        match: (StringMatchProcessConfig matchProcess){
          s = withMatchProcess(matchProcess, s);
        },
        replace: (StringReplaceProcessConfig replaceProcess){
          s = withReplaceProcess(replaceProcess, s);
        },
        replaceAll: (StringReplaceAllProcessConfig replaceAllProcess){
          s = withReplaceAllProcess(replaceAllProcess, s);
        },
      );
    }

    if(varMap == null || varMap.isEmpty){
      return s;
    }
    return s.replaceAllMapped(_varReg, (Match match){
      final String targetVar = match.group(1)!;
      return varMap[targetVar] ?? targetVar;
    });
  }

  String withJoinProcess(StringJoinProcessConfig joinProcess, String raw){
    return joinProcess.target.map((List<StringProcessConfig> process){
      return withProcess(process, raw);
    }).join(joinProcess.separator);
  }

  String withMatchProcess(StringMatchProcessConfig matchProcess, String raw){
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
      return withProcess(matchProcess.failed, raw);
    }
  }

  String withReplaceProcess(StringReplaceProcessConfig replaceProcess, String raw){
    final RegExp regex = RegExp(replaceProcess.regex);

    return raw.replaceFirstMapped(regex, (Match match){
      return replaceProcess.to.replaceAllMapped(_groupReg, (Match match){
        final int group = int.parse(match.group(1)!);
        return match.group(group)!;
      });
    }, replaceProcess.which - 1);
  }

  String withReplaceAllProcess(StringReplaceAllProcessConfig replaceAllProcess, String raw){
    final RegExp regex = RegExp(replaceAllProcess.regex);

    return raw.replaceAllMapped(regex, (Match match){
      return replaceAllProcess.to.replaceAllMapped(_groupReg, (Match match){
        final int group = int.parse(match.group(1)!);
        return match.group(group)!;
      });
    });
  }
}