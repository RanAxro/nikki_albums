
import "plugin.dart";

import "package:flutter/foundation.dart";

import "package:path/path.dart" as p;


final PluginManager globalPluginManager = PluginManager();

class PluginManager extends ChangeNotifier{
  PluginManager();

  final List<Plugin> _plugins = [];

  bool contain(Plugin plugin){
    return _plugins.contains(plugin);
  }
  bool containByPath(String path){
    return _plugins.any((Plugin plugin) => p.equals(path, plugin.position.path));
  }
}