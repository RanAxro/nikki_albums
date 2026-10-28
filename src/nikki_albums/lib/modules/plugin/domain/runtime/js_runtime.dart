
import "runtime.dart";
import "../ffi/js/inject_js.dart";

import "package:quickjs_engine/quickjs_engine.dart";


class PluginJSRuntime extends PluginRuntime{
  static Future<PluginJSRuntime> init({
    String Function(String)? moduleHandler,
    Set<Object> permission = const {},
  }) async{
    final JavascriptRuntime js = QuickJsRuntime2(moduleHandler: moduleHandler);
    js.enableHandlePromises();
    await injectJS(js, permission);

    return PluginJSRuntime._(js, permission: permission);
  }


  final JavascriptRuntime _runtime;

  PluginJSRuntime._(this._runtime, {required super.permission});

  @override
  Future<JsEvalResult> evaluate(String code) async{
    final JsEvalResult result = _runtime.evaluate(code);
    return await _runtime.handlePromise(result);
  }

  @override
  Future<void> dispose() async{
    _runtime.dispose();
  }
}