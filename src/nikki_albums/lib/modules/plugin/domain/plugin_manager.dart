
import "plugin.dart";
import "reader/reader.dart";
import "runner/runner.dart";
import "../model/event_handler.dart";
import "../model/plugin_instance.dart";
import "package:nikki_albums/base/app_state.dart";
import "package:nikki_albums/gen/rust/config/plugin.dart";
import "package:nikki_albums/gen/rust/config/game.dart";

import "dart:convert";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:path/path.dart" as p;

part "plugin_manager.g.dart";


@Riverpod(keepAlive: true)
PluginManager pluginManager(Ref ref){
  final PluginManager manager = PluginManager(ref);
  ref.onDispose(manager.dispose);
  return manager;
}

class PluginManager{
  final Ref _ref;

  PluginManager(this._ref);


  Map<Plugin, bool> get _pluginState => _ref.read(appStateProvider.select((s) => s.pluginState));
  List<PluginInstance> get _pluginInstances => _ref.read(appStateProvider.select((s) => s.pluginInstances));

  bool contain(Plugin plugin){
    return _pluginState.containsKey(plugin);
  }
  bool containByPath(String path){
    return _pluginState.keys.any((plugin) => p.equals(plugin.position.path, path));
  }
  void set(Plugin plugin, [bool usable = true]){
    _ref.read(appStateProvider.notifier).setAppStateWith(
      pluginState: Map.unmodifiable({..._pluginState, plugin: usable}),
    );
  }
  void remove(Plugin plugin){
    final Map<Plugin, bool> next = {..._pluginState}..remove(plugin);
    _ref.read(appStateProvider.notifier).setAppStateWith(
      pluginState: Map.unmodifiable(next),
    );
  }
  void enable(Plugin plugin) => set(plugin, true);
  void disable(Plugin plugin) => set(plugin, false);

  Future<void> reload() async{
    stop();

    bool loading = true;
    final List<PluginInstance> pluginInstances = [];
    final List<GameRegistry> registeredGame = [];

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
          onRegisterLoc: (Map<String, String> localeAndPathMap) async{
            final Map<String, Map<String, dynamic>> localizations = {};
            for(final MapEntry<String, String> entry in localeAndPathMap.entries){
              final String value = await reader.readFileAsString(entry.value);
              final Map<String, dynamic> loc = jsonDecode(value);
              localizations[entry.key] = loc;
            }

            _ref.read(appStateProvider.notifier).setAppStateWith(
              registerLoc: Map.unmodifiable({
                ..._ref.read(appStateProvider).registerLoc,
                info.uuid: localizations,
              }),
            );
          },
          onRegisterGlobalLoc: (Map<String, String> localeAndPathMap) async{
            final Map<String, Map<String, dynamic>> localizations = {};
            for(final MapEntry<String, String> entry in localeAndPathMap.entries){
              final String value = await reader.readFileAsString(entry.value);
              final Map<String, dynamic> loc = jsonDecode(value);
              localizations[entry.key] = loc;
            }

            _ref.read(appStateProvider.notifier).setAppStateWith(
              registerGlobalLoc: Map.unmodifiable({
                ..._ref.read(appStateProvider).registerGlobalLoc,
                info.uuid: localizations,
              }),
            );
          },
          onRegisterGame: (GameRegistry gameRegistry){
            registeredGame.add(gameRegistry);
            if(!loading){
              _ref.read(appStateProvider.notifier).setAppStateWith(
                registerGame: List.unmodifiable([..._ref.read(appStateProvider).registerGame, gameRegistry]),
              );
            }
          },
        ), reader);
        pluginInstances.add(PluginInstance(plugin: plugin, info: info, reader: reader, runner: runner));
      }catch(e){
        print(e);
      }
    }

    loading = false;
    _ref.read(appStateProvider.notifier).setAppStateWith(
      pluginInstances: List.unmodifiable(pluginInstances),
      registerGame: List.unmodifiable(registeredGame),
    );print(pluginInstances);
  }

  void stop(){
    dispose();
    _ref.read(appStateProvider.notifier).setAppStateWith(
      pluginInstances: List.unmodifiable([]),
      registerGame: List.unmodifiable([]),
    );
  }

  void dispose(){
    for(final PluginInstance instance in _pluginInstances){
      instance.runner.dispose();
    }
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