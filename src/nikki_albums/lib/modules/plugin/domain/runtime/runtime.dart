
export "js_runtime.dart";


abstract class PluginRuntime{
  final Set<Object> permission;

  PluginRuntime({required this.permission});

  Future<void> evaluate(String code);

  Future<void> dispose();
}