
import "../reader/reader.dart";
import "../runtime/js_runtime.dart";
import "../ffi/js/js_bridge.dart";
import "../../model/exception.dart";
import "package:nikki_albums/gen/rust/config/game.dart";

import "package:quickjs_engine/js_eval_result.dart";
import "package:path/path.dart" as p;

part "js_runner.dart";


abstract class PluginRunner{
  static Future<PluginRunner> init({required PluginReader reader, required Set<Object> permission}) async{
    final PluginInfo info = await reader.readInfo();

    switch(info.scriptInfo){
      case ScriptInfo_NES():
      // TODO: Handle this case.
        throw UnimplementedError();
      case ScriptInfo_JS(field0: final scriptInfo):
        final Map<String, String> modules = {};
        for(final MapEntry<String, String> entry in scriptInfo.modules.entries){
          final String scriptPath = p.join(p.dirname(scriptInfo.entrance), entry.value);
          modules[entry.key] = await reader.readFileAsString(scriptPath);
        }
        final PluginJSRuntime runtime = await PluginJSRuntime.init(permission: permission, moduleHandler: (String moduleName){
          return modules[moduleName] ?? "";
        });
        final String entrance = await reader.readFileAsString(scriptInfo.entrance);
        final JsEvalResult result = await runtime.evaluate(entrance);
        if(result.isError){
          await runtime.dispose();
          throw PluginScriptMalfunctionedException(scriptType: "JS", script: entrance, error: result.stringResult);
        }
        return PluginJSRunner._(reader: reader, runtime: runtime);
      case ScriptInfo_Wasm():
      // TODO: Handle this case.
        throw UnimplementedError();
    }
  }


  final PluginReader reader;

  const PluginRunner({required this.reader});

  Future<List<Game>> searchGame(String id);

  void dispose();
}