
import "package:nikki_albums/modules/plugin/domain/plugin.dart";

import "package:flutter/widgets.dart";
import "dart:io";
import "dart:typed_data";

import "package:forui/forui.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:nikki_albums/modules/plugin/domain/plugin_manager.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as p;


Future<void> scanPlugin(WidgetRef ref) async{
  final String path = p.join((await getApplicationDocumentsDirectory()).path, "Nikki Albums", "Plugins");
  final Directory dir = Directory(path);
  final manager = ref.read(pluginManagerProvider);
  await for(final entity in dir.list()){
    final Plugin plugin = Plugin(entity);
    manager.set(plugin, true);
  }
  await manager.reload();
}

class PluginPage extends ConsumerWidget{
  const PluginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return FResizable(
      axis: Axis.horizontal,
      divider: FResizableDivider.divider,
      children: [
        FResizableRegion.fixed(
          extent: 300,
          minExtent: 100,
          builder: (context, data, child) => child!,
          child: PluginStore(),
        ),
        FResizableRegion.flex(
          builder: (context, data, child) => child!,
          child: PluginManagementList(),
        ),
      ],
    );
  }
}

class PluginData{
  final Plugin plugin;
  final PluginInfo info;
  final Uint8List? iconBytes;

  const PluginData({
    required this.plugin,
    required this.info,
    this.iconBytes,
  });
}

class PluginManagementList extends ConsumerStatefulWidget{
  const PluginManagementList({super.key});

  @override
  ConsumerState<PluginManagementList> createState() => _PluginManagementListState();
}

class _PluginManagementListState extends ConsumerState<PluginManagementList>{
  Future<PluginData> getPluginData(Plugin plugin) async{
    final PluginReader reader = await plugin.getReader();
    final PluginInfo info = await reader.readInfo();
    return PluginData(plugin: plugin, info: info);
  }

  Stream<List<PluginData>> getPluginDataStream(Iterable<Plugin> plugins) async*{
    final List<PluginData> data = [];
    for(final Plugin plugin in plugins){
      try{
        final PluginData singleData = await getPluginData(plugin);
        data.add(singleData);
        yield data;
      }catch(_){
        continue;
      }
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final Map<Plugin, bool> plugins = ref.watch(pluginStateProvider);

    final theme = context.theme;
    return StreamBuilder(
      stream: getPluginDataStream(plugins.keys),
      builder: (BuildContext context, AsyncSnapshot<List<PluginData>> snapshot){
        // 1. 处理加载中状态
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: FCircularProgress());
        }
        // 2. 处理错误状态
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final pluginDataList = snapshot.data ?? [];

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: pluginDataList.length,
          separatorBuilder: (context, index){
            return const SizedBox(height: 6);
          },
          itemBuilder: (BuildContext context, int index){
            final PluginData data = pluginDataList[index];
            return FCard(
              child: Padding(
                padding: const .fromLTRB(16, 12, 16, 16),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    if(data.iconBytes != null)
                      Image.memory(data.iconBytes!),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            data.info.uuid,
                            style: theme.typography.body.md.copyWith(
                              fontWeight: .w500,
                              color: theme.colors.foreground,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            data.plugin.position.path,
                            style: theme.typography.body.sm.copyWith(
                              color: theme.colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FormField(
                      initialValue: plugins[data.plugin],
                      onSaved: (value){
                        // Save values somewhere.
                      },
                      validator: (value) => null, // No validation required.
                      builder: (state) => FSwitch(
                        value: state.value ?? false,
                        onChange: (value){
                          state.didChange(value);
                          ref.read(pluginStateProvider.notifier).set(data.plugin, value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class PluginStore extends ConsumerWidget{
  const PluginStore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Text("插件商城");
  }
}