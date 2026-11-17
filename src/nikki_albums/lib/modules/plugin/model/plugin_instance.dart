
import "../domain/plugin.dart";
import "../domain/reader/reader.dart";
import "../domain/runner/runner.dart";
import "package:nikki_albums/gen/rust/config/plugin.dart";


class PluginInstance{
  final Plugin plugin;
  final PluginInfo info;
  final PluginReader reader;
  final PluginRunner runner;

  PluginInstance({
    required this.plugin,
    required this.info,
    required this.reader,
    required this.runner,
  });
}