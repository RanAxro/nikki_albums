
import "device_game_picker.dart";
import "custom_account_adder.dart";
import "package:nikki_albums/base/app_state.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";
import "package:nikki_albums/modules/plugin/domain/plugin.dart";
import "package:nikki_albums/modules/plugin/domain/plugin_manager.dart";
import "package:nikki_albums/modules/plugin/model/game_helper.dart";
import "package:nikki_albums/modules/config_helper/domain/config_helper.dart";
import "package:nikki_albums/modules/config_helper/model/image_rule.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/rules/icon_rule.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";

import "package:flutter/widgets.dart";

import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:forui/forui.dart";
import "package:forui_hooks/forui_hooks.dart";
import "package:path/path.dart" as p;



const _menuGroupId = [];

class GameSelectorPopoverMenu extends HookConsumerWidget{
  final Widget Function(BuildContext context, FPopoverController controller, Widget? child) builder;
  final Widget? child;

  const GameSelectorPopoverMenu({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final PluginManager manager = ref.watch(pluginManagerProvider);
    final List<GameRegistry> registeredGame = ref.watch(pluginRegisteredGameProvider);

    final Map<String, Future> tasks = {};
    final Map<String, Widget> widgetCache = {};

    final FPopoverController controller = useFPopoverController();

    return FPopoverMenu.tiles(
      hideRegion: FPopoverHideRegion.excludeChild,
      groupId: _menuGroupId,
      control: FPopoverControl.managed(controller: controller),
      intrinsicWidth: false,
      autofocus: true,
      menuAnchor: AlignmentGeometry.topLeft,
      childAnchor: AlignmentGeometry.bottomLeft,
      menu: buildGameMenu(
        context: context,
        onSelect: (DeviceGame deviceGame, String account){
          ref.read(appStateProvider.notifier).setAppStateWith(
            selectedDeviceGame: DeviceGameSession(
              deviceGame: deviceGame,
              account: account,
            ),
          );
          controller.hide();
        },
        tasks: tasks,
        widgetCache: widgetCache,
        manager: manager,
        registeredGame: registeredGame,
      ),
      builder: (BuildContext context, FPopoverController controller, Widget? child){
        return builder(context, controller, child);
      },
      child: child,
    );
  }
}

List<FTileGroupMixin> buildGameMenu({
  required BuildContext context,
  required void Function(DeviceGame deviceGame, String account) onSelect,
  required Map<String, Future> tasks,
  required Map<String, Widget> widgetCache,
  required PluginManager manager,
  required List<GameRegistry> registeredGame,
}){
  return [
    FTileGroupMixin.builder(
      count: registeredGame.length,
      tileBuilder: (BuildContext context, int index){
        final GameRegistry gameRegistry = registeredGame[index];
        final String pluginUuid = gameRegistry.ownership;
        final PluginRunner runner = manager.getInstanceRunnerByUuid(pluginUuid);
        final String uniqueId = GameHelper.generateUniqueId(pluginUuid, gameRegistry.uuid);

        final String searchGameTaskId = "task-$uniqueId-searchDeviceGame";
        tasks[searchGameTaskId] ??= runner.searchDeviceGame(uniqueId, NNativeFileSystem.connect(""));
        final String gameIconCacheId = "widgetCache-$uniqueId-icon";
        widgetCache[gameIconCacheId] ??= IconRuleHelper.resolve(gameRegistry.icon, reader: runner.reader);
        return FutureBuilder(
          future: tasks[searchGameTaskId] as Future<List<DeviceGame>>,
          builder: (BuildContext context, AsyncSnapshot<List<DeviceGame>> snapshot){
            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return FTileMixin.tile(
                prefix: SizedBox(
                  width: 30,
                  height: 30,
                  child: widgetCache[gameIconCacheId],
                ),
                title: Text(TextRuleHelper.resolve(gameRegistry.name, context: context, pluginUuid: pluginUuid)),
                suffix: const FCircularProgress(),
              );
            }
            if(snapshot.hasError){
              return FTileMixin.tile(
                prefix: SizedBox(
                  width: 30,
                  height: 30,
                  child: widgetCache[gameIconCacheId],
                ),
                title: Text(TextRuleHelper.resolve(gameRegistry.name, context: context, pluginUuid: pluginUuid)),
                suffix: const Icon(FLucideIcons.chevronRight),
              );
            }
            final List<DeviceGame> deviceGames = snapshot.data!;
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child){
                final List<DeviceGame> pickedDeviceGames = ref.watch(appStateProvider.select((p) => p.pickedDeviceGame));

                return FTileMixin.submenu(
                  submenuIntrinsicWidth: false,
                  prefix: SizedBox(
                    width: 30,
                    height: 30,
                    child: widgetCache[gameIconCacheId],
                  ),
                  title: Text(TextRuleHelper.resolve(gameRegistry.name, context: context, pluginUuid: pluginUuid)),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  menu: buildDeviceGameMenu(
                    context: context,
                    onSelect: onSelect,
                    tasks: tasks,
                    widgetCache: widgetCache,
                    gameRegistry: gameRegistry,
                    pluginUuid: pluginUuid,
                    runner: runner,
                    uniqueId: uniqueId,
                    deviceGames: [...pickedDeviceGames, ...deviceGames],
                  ),
                );
              },
            );
          },
        );
      },
    ),
    FTileGroupMixin.group(
      children: [
        FTileMixin.tile(
          prefix: const Icon(FLucideIcons.list),
          title: const Text("添加游戏拓展"),
          onPress: (){
            print("跳转到插件");
          },
        ),
      ],
    ),
  ];
}

List<FTileGroupMixin> buildDeviceGameMenu({
  required BuildContext context,
  required void Function(DeviceGame deviceGame, String account) onSelect,
  required Map<String, Future> tasks,
  required Map<String, Widget> widgetCache,
  required GameRegistry gameRegistry,
  required String pluginUuid,
  required PluginRunner runner,
  required String uniqueId,
  required List<DeviceGame> deviceGames,
}){
  return [
    FTileGroupMixin.builder(
      count: deviceGames.length,
      tileBuilder: (BuildContext context, int index){
        final DeviceGame deviceGame = deviceGames[index];

        final String getGameIconTaskId = "task-$uniqueId-${deviceGame.toJson()}-getDeviceGameIcon";
        tasks[getGameIconTaskId] ??= runner.getDeviceGameIcon(deviceGame);
        final Widget prefix = FutureBuilder(
          future: tasks[getGameIconTaskId] as Future<IconRule?>,
          builder: (BuildContext context, AsyncSnapshot<IconRule?> snapshot){
            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return const FCircularProgress();
            }
            if(snapshot.hasError){
              return const SizedBox();
            }
            if(snapshot.data == null){
              return const SizedBox();
            }
            final String deviceGameIconCacheId = "widgetCache-$uniqueId-${deviceGame.installPath}-icon";
            widgetCache[deviceGameIconCacheId] ??= IconRuleHelper.resolve(snapshot.data!, reader: runner.reader);
            return SizedBox(
              height: 20,
              child: widgetCache[deviceGameIconCacheId],
            );
          },
        );

        final String getGameNameTaskId = "task-$uniqueId-${deviceGame.toJson()}-getDeviceGameName";
        tasks[getGameNameTaskId] ??= runner.getDeviceGameName(deviceGame);
        final Widget title = FutureBuilder(
          future: tasks[getGameNameTaskId] as Future<TextRule>,
          builder: (BuildContext context, AsyncSnapshot<TextRule> snapshot){
            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return const FCircularProgress();
            }
            if(snapshot.hasError || snapshot.data == null){
              return Text(deviceGame.installPath);
            }
            return Text(TextRuleHelper.resolve(snapshot.data!, context: context, pluginUuid: pluginUuid));
          },
        );

        final String searchAccountTaskId = "task-$uniqueId-${deviceGame.toJson()}-searchAccount";
        tasks[searchAccountTaskId] ??= runner.searchAccount(NNativeFileSystem.connect(deviceGame.installPath), deviceGame);
        return FutureBuilder(
          future: tasks[searchAccountTaskId] as Future<List<String>>,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot){
            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return FTileMixin.tile(
                onPress: (){},
                prefix: prefix,
                title: title,
                suffix: const FCircularProgress(),
              );
            }
            if(snapshot.hasError || snapshot.data == null || (snapshot.data!.isEmpty && gameRegistry.customAccountAdder == null)){
              return FTileMixin.tile(
                onPress: (){},
                prefix: prefix,
                title: title,
              );
            }
            final List<String> accounts = snapshot.data!;
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child){
                final List<DeviceGameAccount> hiddenAccounts = ref.watch(appStateProvider.select((p) => p.hiddenAccount));
                final List<DeviceGameAccount> topRankedAccount = ref.watch(appStateProvider.select((p) => p.topRankedAccount));
                final List<DeviceGameAccount> addedCustomAccounts = ref.watch(appStateProvider.select((p) => p.addedCustomAccount));
                final List<DeviceGameAccountNote> accountNotes = ref.watch(appStateProvider.select((p) => p.accountNote));

                return FTileMixin.submenu(
                  submenuIntrinsicWidth: false,
                  prefix: prefix,
                  title: title,
                  suffix: const Icon(FLucideIcons.chevronRight),
                  menu: buildAccountMenu(
                    context: context,
                    onSelect: onSelect,
                    tasks: tasks,
                    widgetCache: widgetCache,
                    gameRegistry: gameRegistry,
                    pluginUuid: pluginUuid,
                    runner: runner,
                    uniqueId: uniqueId,
                    deviceGame: deviceGame,
                    accounts: accounts,
                    hiddenAccounts: hiddenAccounts.where((a) => a.deviceGame == deviceGame).map((a) => a.account),
                    topRankedAccount: topRankedAccount.where((a) => a.deviceGame == deviceGame).map((a) => a.account),
                    addedCustomAccounts: addedCustomAccounts.where((a) => a.deviceGame == deviceGame).map((a) => a.account),
                    accountNotes: accountNotes.where((a) => a.deviceGameAccount.deviceGame == deviceGame),
                  ),
                );
              },
            );
          },
        );
      }
    ),
    if(gameRegistry.deviceGamePicker != null)
      FTileGroupMixin.group(
        children: [
          FTileMixin.tile(
            onPress: (){
              showFDialog(
                context: context,
                builder: (context, style, animation) => DeviceGamePickerDialog(
                  pluginUuid: pluginUuid,
                  deviceGamePickerConfig: gameRegistry.deviceGamePicker!,
                  style: style,
                  animation: animation,
                  validate: (String path, String name) async{
                    final PickedDeviceGameResult pickedResult = await runner.notifyPickDeviceGame(uniqueId, NNativeFileSystem.connect(path), name);
                    return pickedResult.map(
                      ok: (PickedDeviceGameResult_Ok deviceGame){
                        final String installPath = p.canonicalize(p.join(path, deviceGame.field0.installPath));
                        return PickedDeviceGameResult.ok(deviceGame.field0.copyWith(installPath: installPath));
                      },
                      err: (PickedDeviceGameResult_Err message) => message,
                    );
                  },
                ),
              );
            },
            title: Text(gameRegistry.deviceGamePicker?.entranceBtnText == null
              ? "定位游戏"
              : TextRuleHelper.resolve(gameRegistry.deviceGamePicker!.entranceBtnText!, context: context, pluginUuid: pluginUuid),
            ),
          ),
        ],
      ),
  ];
}

List<FTileGroupMixin> buildAccountMenu({
  required BuildContext context,
  required void Function(DeviceGame deviceGame, String account) onSelect,
  required Map<String, Future> tasks,
  required Map<String, Widget> widgetCache,
  required GameRegistry gameRegistry,
  required String pluginUuid,
  required PluginRunner runner,
  required String uniqueId,
  required DeviceGame deviceGame,
  required Iterable<String> accounts,
  required Iterable<String> hiddenAccounts,
  required Iterable<String> topRankedAccount,
  required Iterable<String> addedCustomAccounts,
  required Iterable<DeviceGameAccountNote> accountNotes,
}){
  final List<String> displayAccounts = ({
    ...topRankedAccount,
    ...addedCustomAccounts,
    ...accounts,
  }..removeAll(hiddenAccounts)).toList();

  return [
    FTileGroupMixin.builder(
      count: displayAccounts.length,
      tileBuilder: (BuildContext context, int index){
        final String account = displayAccounts[index];
        final DeviceGameAccount deviceGameAccount = DeviceGameAccount(
          deviceGame: deviceGame,
          account: account,
        );

        final String getAccountAvatarTaskId = "task-$uniqueId-${deviceGame.installPath}-$account-getAccountAvatar";
        tasks[getAccountAvatarTaskId] ??= runner.getAccountAvatar(NNativeFileSystem.connect(deviceGame.installPath), deviceGame, account);
        final Widget prefix = FutureBuilder(
          future: tasks[getAccountAvatarTaskId] as Future<ImageRule?>,
          builder: (BuildContext context, AsyncSnapshot<ImageRule?> snapshot){
            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return const FCircularProgress();
            }
            if(snapshot.hasError || snapshot.data == null){
              return const SizedBox();
            }
            final String accountAvatarCacheId = "widgetCache-$uniqueId-${deviceGame.installPath}-$account-image";
            widgetCache[accountAvatarCacheId] ??= ImageRuleHelper.resolve(snapshot.data!);
            return SizedBox(
              height: 20,
              child: widgetCache[accountAvatarCacheId],
            );
          },
        );

        final String getAccountNameTaskId = "task-$uniqueId-${deviceGame.installPath}-$account-getAccountName";
        tasks[getAccountNameTaskId] ??= runner.getAccountName(NNativeFileSystem.connect(deviceGame.installPath), deviceGame, account);
        final Widget title = FutureBuilder(
          future: tasks[getAccountNameTaskId] as Future<TextRule?>,
          builder: (BuildContext context, AsyncSnapshot<TextRule?> snapshot){
            final String? note = accountNotes.where((n) => n.deviceGameAccount.account == account).firstOrNull?.note;

            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return const FCircularProgress();
            }
            if(snapshot.hasError || snapshot.data == null){
              return Text(note == null ? account : "$note ($account)");
            }
            final String text = TextRuleHelper.resolve(snapshot.data!, context: context, pluginUuid: pluginUuid);
            return Text(note == null ? text : "$note ($text)");
          },
        );

        return HookConsumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child){
            final Set<String> starredAccounts = ref.watch(appStateProvider.select((p) => p.starredAccount))
              .where((a) => a.deviceGame == deviceGame).map((a) => a.account).toSet();

            final FPopoverController controller = useFPopoverController();

            return FContextMenu(
              control: FPopoverControl.managed(controller: controller),
              hideRegion: FPopoverHideRegion.anywhere,
              groupId: _menuGroupId,
              menu: [
                FItemGroupMixin.group(
                  children: [
                    FItemMixin.item(
                      prefix: const Icon(FLucideIcons.notebook),
                      title: const Text("备注"),
                      onPress: (){
                        ref.read(appStateProvider.notifier).setAppStateWith(
                          accountNote: [DeviceGameAccountNote(
                            deviceGameAccount: deviceGameAccount,
                            note: "Note",
                          ), ...ref.read(appStateProvider).accountNote],
                        );
                        controller.hide();
                      },
                    ),
                    if(!topRankedAccount.contains(account))
                      FItemMixin.item(
                        prefix: const Icon(FLucideIcons.pin),
                        title: const Text("置顶"),
                        onPress: (){
                          ref.read(appStateProvider.notifier).setAppStateWith(
                            topRankedAccount: [deviceGameAccount, ...ref.read(appStateProvider).topRankedAccount],
                          );
                          controller.hide();
                        },
                      ),
                    if(topRankedAccount.contains(account))
                      FItemMixin.item(
                        prefix: const Icon(FLucideIcons.pin),
                        title: const Text("取消置顶"),
                        onPress: (){
                          ref.read(appStateProvider.notifier).setAppStateWith(
                            topRankedAccount: ref.read(appStateProvider).topRankedAccount.toList()..remove(deviceGameAccount),
                          );
                          controller.hide();
                        },
                      ),
                    if(starredAccounts.contains(account))
                      FItemMixin.item(
                        prefix: const Icon(FLucideIcons.star),
                        title: const Text("取消标星"),
                        onPress: (){
                          controller.hide();
                        },
                      ),
                    if(!starredAccounts.contains(account))
                      FItemMixin.item(
                        prefix: const Icon(FLucideIcons.star),
                        title: const Text("标星"),
                        onPress: (){

                        },
                      ),
                    FItemMixin.item(
                      prefix: const Icon(FLucideIcons.minus),
                      title: const Text("隐藏"),
                      onPress: (){
                        /// TODO 首次隐藏提示
                        ref.read(appStateProvider.notifier).setAppStateWith(
                          hiddenAccount: [deviceGameAccount, ...ref.read(appStateProvider).hiddenAccount],
                        );
                        controller.hide();
                      },
                    ),
                    if(addedCustomAccounts.contains(account))
                      FItemMixin.item(
                        prefix: const Icon(FLucideIcons.delete),
                        title: const Text("移除"),
                        onPress: (){
                          /// TODO 弹窗二次确认
                          ref.read(appStateProvider.notifier).setAppStateWith(
                            addedCustomAccount: ref.read(appStateProvider).addedCustomAccount.toList()..remove(deviceGameAccount),
                          );
                          controller.hide();
                        },
                      ),
                  ],
                ),
              ],
              child: child,
            );
          },
          child: FTileMixin.tile(
            onPress: (){
              onSelect(deviceGame, account);
            },
            prefix: prefix,
            title: title,
          ),
        );
      },
    ),
    if(gameRegistry.customAccountAdder != null)
      FTileGroupMixin.group(
        children: [
          FTileMixin.tile(
            onPress: (){
              showFDialog(
                context: context,
                builder: (context, style, animation) => CustomAccountAdderDialog(
                  deviceGame: deviceGame,
                  customAccountAdderConfig: gameRegistry.customAccountAdder!,
                  style: style,
                  animation: animation,
                  validate: (String account){
                    return runner.notifyAddCustomAccount(NNativeFileSystem.connect(deviceGame.installPath), deviceGame, account);
                  },
                ),
              );
            },
            title: Text(gameRegistry.deviceGamePicker?.entranceBtnText == null
                ? "添加账号"
                : TextRuleHelper.resolve(gameRegistry.customAccountAdder!.entranceBtnText!, context: context, pluginUuid: pluginUuid),
            ),
          ),
        ],
      ),
  ];
}



