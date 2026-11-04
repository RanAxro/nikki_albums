export "plugin_manager_state.dart";

import "plugin_manager_state.dart";
import "plugin.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:path/path.dart" as p;


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

class PluginManager{
  final Ref _ref;

  PluginManager(this._ref);

  final List<PluginInstance> _pluginInstances = [];

  PluginState get _pluginStateNotifier => _ref.read(pluginStateProvider.notifier);
  Map<Plugin, bool> get _pluginState => _ref.read(pluginStateProvider);

  bool contain(Plugin plugin) => _pluginStateNotifier.contain(plugin);
  bool containByPath(String path) => _pluginStateNotifier.containByPath(path);
  void set(Plugin plugin, [bool usable = true]) => _pluginStateNotifier.set(plugin, usable);
  void remove(Plugin plugin) => _pluginStateNotifier.remove(plugin);
  void enable(Plugin plugin) => _pluginStateNotifier.enable(plugin);
  void disable(Plugin plugin) => _pluginStateNotifier.disable(plugin);

  Future<void> reload() async{
    dispose();

    bool loading = true;
    final List<String> registeredGame = [];

    for(final MapEntry<Plugin, bool> entry in _pluginState.entries){
      if(!entry.value){
        continue;
      }
      final Plugin plugin = entry.key;
      try{
        final PluginReader reader = await plugin.getReader();
        final PluginInfo info = await reader.readInfo();
        final PluginRunner runner = await plugin.getRunner(PluginEventHandler(
          onRequestPluginUuid: () => info.uuid,
          onRegisterGame: (String uniqueId){
            registeredGame.add(uniqueId);
            if(!loading){
              _ref.read(pluginRegisteredGameProvider.notifier).add(uniqueId);
            }
          },
        ), reader);
        _pluginInstances.add(PluginInstance(plugin: plugin, info: info, reader: reader, runner: runner));
      }catch(e){
        print(e);
      }
    }

    loading = false;
    _ref.read(pluginRegisteredGameProvider.notifier).replaceAll(registeredGame);
  }

  void stop(){
    dispose();
    _ref.read(pluginRegisteredGameProvider.notifier).clear();
  }

  void dispose(){
    for(final PluginInstance instance in _pluginInstances){
      instance.runner.dispose();
    }
    _pluginInstances.clear();
  }

  PluginRunner getInstanceRunner(Plugin plugin){
    return _pluginInstances.firstWhere((PluginInstance instance) => instance.plugin == plugin).runner;
  }

  PluginRunner getInstanceRunnerByPath(String path){
    return _pluginInstances.firstWhere((PluginInstance instance) => p.equals(instance.plugin.position.path, path)).runner;
  }

  PluginRunner getInstanceRunnerByUuid(String uuid){
    return _pluginInstances.firstWhere((PluginInstance instance) => instance.info.uuid == uuid).runner;
  }
}