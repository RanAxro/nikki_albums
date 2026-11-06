
import "plugin.dart";
import "plugin_manager.dart";
import "package:nikki_albums/gen/rust/config/game.dart";

import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:path/path.dart" as p;

part "plugin_manager_state.g.dart";


@Riverpod(keepAlive: true)
PluginManager pluginManager(Ref ref){
  final PluginManager manager = PluginManager(ref);
  ref.onDispose(manager.dispose);
  return manager;
}

@Riverpod(keepAlive: true)
class PluginState extends _$PluginState{
  @override
  Map<Plugin, bool> build() => const {};

  bool contain(Plugin plugin) => state.containsKey(plugin);

  bool containByPath(String path) =>
    state.keys.any((plugin) => p.equals(path, plugin.position.path));

  void set(Plugin plugin, [bool usable = true]) =>
    state = Map.unmodifiable({...state, plugin: usable});

  void remove(Plugin plugin){
    final next = {...state}..remove(plugin);
    state = Map.unmodifiable(next);
  }

  void enable(Plugin plugin) => set(plugin, true);
  void disable(Plugin plugin) => set(plugin, false);
  void clear() => state = const {};
}

@Riverpod(keepAlive: true)
class PluginRegisteredIcon extends _$PluginRegisteredIcon{
  @override
  Map<String, dynamic> build() => const {};

  void put(String key, dynamic value){
    state = Map.unmodifiable({...state, key: value});
  }
  void putAll(Map<String, dynamic> values){
    state = Map.unmodifiable({...state, ...values});
  }
  void remove(String key){
    final next = {...state}..remove(key);
    state = Map.unmodifiable(next);
  }
  void clear() => state = const {};
}

@Riverpod(keepAlive: true)
class PluginRegisteredGame extends _$PluginRegisteredGame{
  @override
  List<GameRegistry> build() => const [];

  void replaceAll(Iterable<GameRegistry> ids) => state = List.unmodifiable(ids);
  void add(GameRegistry id) => state = List.unmodifiable([...state, id]);
  void clear() => state = const [];
}