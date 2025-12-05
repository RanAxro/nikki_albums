import "package:nikkialbums/info.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/pages/setting/setting.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/api/system/system.dart";
import "package:nikkialbums/api/path.dart";

import "dart:io";
import "package:flutter/material.dart";

import "package:file_picker/file_picker.dart";
import "package:easy_localization/easy_localization.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";

class Frame extends StatefulWidget{
  const Frame(key) : super(key: key);

  GlobalKey get globalKey => key as GlobalKey;

  @override
  State<StatefulWidget> createState() => _FrameState();
}
class _FrameState extends State<Frame>{
  void whenLangChanged(){
    final List lang = AppState.lang.value.split("-");
    widget.globalKey.currentContext?.setLocale(Locale(lang[0], lang[1]));
  }
  void whenThemeChanged(){
    setState((){

    });
  }

  @override
  void initState(){
    super.initState();
    AppState.lang.addListener(whenLangChanged);
    AppState.theme.addListener(whenThemeChanged);
  }

  @override
  Widget build(BuildContext context){
    return AppTheme(
      theme: AppState.theme.value,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context){
              if(Platform.isWindows){
                return WindowBorder(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                  child: Column(
                    children: [
                      const WindowTitleBar(),
                      Expanded(
                        child: Content(controller: pages),
                      ),
                    ],
                  ),
                );
              }
              return Placeholder();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    AppState.lang.removeListener(whenLangChanged);
    AppState.theme.removeListener(whenThemeChanged);
  }
}



class WindowTitleBar extends StatelessWidget{
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      height: windowTitleBarHeight,
      color: AppTheme.of(context)!.colorScheme.secondary.color,
      child: Stack(
        children: [
          Positioned.fill(
            child: MoveWindow(),
          ),
          Row(
            children: [
              // Icon
              IgnorePointer(
                ignoring: true,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: sideBarWidth,
                  height: windowTitleBarHeight,
                  child: Image.asset("assets/logo/nikkialbums.webp"),
                ),
              ),

              const AccountButton(),

              /// top window button
              SmallSwitch(
                colorRole: ColorRoles.secondary,
                onChange: (bool value){
                  doTopWindow(value);
                },
                child: Image.asset("assets/icon/top.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
              ),
              block5W,

              /// minimize window button
              SmallButton(
                width: windowTitleBarHeight + 10,
                height: windowTitleBarHeight,
                borderRadius: 0,
                colorRole: ColorRoles.secondary,
                onClick: (){
                  appWindow.minimize();
                },
                child: Image.asset("assets/icon/minimize.webp", height: 14, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
              ),

              /// close window button
              SmallButton(
                width: windowTitleBarHeight + 10,
                height: windowTitleBarHeight,
                borderRadius: 0,
                colorRole: ColorRoles.error,
                onClick: () async{
                  await AppState.save();
                  appWindow.close();
                },
                child: Image.asset("assets/icon/cross.webp", height: 14, color: AppTheme.of(context)!.colorScheme.error.onColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class AccountButton extends StatelessWidget{
  const AccountButton({super.key});

  Row _itemButton({
    required BuildContext context,
    ImageProvider? image,
    required String text,
  }){
    return Row(
      spacing: listSpacing,
      children: [
        image == null ? block0 : Image(image: image, height: smallButtonSize - 10),
        Text(text, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
      ],
    );
  }

  RFutureBuilder<List<String>> _itemBuilder(Game game){
    return RFutureBuilder<List<String>>(
      future: game.findUid(),
      builder: (BuildContext context, List<String> uidList){
        if(uidList.isEmpty){
          return MenuItemButton(
            onPressed: (){
              game.selectedUid = null;
              AppState.currentGame.value = game;
            },
            child: _itemButton(context: context, image: game.logoImage, text: game.name),
          );
        }
        return SubmenuButton(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
          ),
          menuChildren: List.generate(
            uidList.length,
            (int index){
              final String uid = uidList[index];
              return MenuItemButton(
                onPressed: (){
                  game.selectedUid = uid;
                  AppState.currentGame.value = game;
                },
                child: RFutureBuilder(
                  future: game.findAvatarByUid(uid),
                  waitingBuilder: (BuildContext context, Widget indicator){
                    return _itemButton(context: context, text: uid);
                  },
                  builder: (BuildContext context, avatar){
                    return _itemButton(context: context, image: avatar == null ? null : FileImage(avatar.file), text: uid);
                  },
                ),
              );
            }
          ),
          child: _itemButton(context: context, image: game.logoImage, text: game.name),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){

    /// menu
    final Widget menu = ValueListenableBuilder(
      valueListenable: AppState.customGame,
      builder: (BuildContext context, List<Game> customGame, Widget? child){
        final List<Widget> menuChildren = <Widget>[];

        /// find Game from device
        menuChildren.add(
          RFutureBuilder<List<Game>>(
            future: Game.find(),
            builder: (BuildContext context, List<Game> gameList){
              return Column(
                children: List.generate(
                  gameList.length,
                  (int index) =>_itemBuilder(gameList[index]),
                ),
              );
            }
          ),
        );

        /// user's custom Game
        menuChildren.addAll(
          List.generate(
            AppState.customGame.value.length,
            (int index) => _itemBuilder(AppState.customGame.value[index]),
          ),
        );

        /// the last is "add" button, user can add custom Game
        menuChildren.add(
          MenuItemButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => CustomAccountDialog(),
              );
            },
            child: Text(context.tr("addCustomAccountButton"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
          )
        );

        return MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
          ),
          builder: (BuildContext context, MenuController controller, Widget? child){
            return SmallButton(
              padding: const EdgeInsets.all(6),
              width: null,
              height: smallButtonSize,
              colorRole: ColorRoles.secondary,
              onClick: (){
                controller.isOpen ? controller.close() : controller.open();
              },
              child: child,
            );
          },
          menuChildren: menuChildren,
          child: child,
        );
      },
      /// button content
      child: ValueListenableBuilder<Game?>(
        valueListenable: AppState.currentGame,
        builder: (BuildContext context, Game? currentGame, Widget? child){
          if(currentGame == null){
            return Row(
              spacing: listSpacing,
              children: [
                Image.asset("assets/icon/select.webp", height: smallButtonSize - 10, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
                Text(context.tr("selectAccountButton"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
              ],
            );
          }

          return ListenableBuilder(
            listenable: currentGame,
            builder: (BuildContext context, Widget? child){
              return Row(
                spacing: listSpacing,
                children: [
                  RFutureBuilder(
                    future: currentGame.avatarImage,
                    builder: (BuildContext context, FileImage? image){
                      return Image(image: image ?? currentGame.logoImage);
                    },
                  ),
                  Text(currentGame.selectedUid ?? currentGame.launcherChannel.name, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                ],
              );
            }
          );
        },
      ),
    );

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: UnconstrainedBox(
          child: menu,
        ),
      ),
    );
  }
}


class CustomAccountDialog extends StatefulWidget{
  const CustomAccountDialog({super.key});

  @override
  State<CustomAccountDialog> createState() => _CustomAccountDialogState();
}
class _CustomAccountDialogState extends State<CustomAccountDialog>{
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> isAlreadyLocate = ValueNotifier<bool>(false);
  final ValueNotifier<String?> launcherPath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> installPath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> errorInfo = ValueNotifier<String?>(null);

  bool verify() => launcherPath.value != null && installPath.value != null;

  bool isExistSame(){
    final List<Game> existingGame = [];
    if(Game.cacheGameList != null) existingGame.addAll(Game.cacheGameList!);
    existingGame.addAll(AppState.customGame.value);

    return existingGame.any((game) => game.launcherPath?.path == launcherPath.value && game.installPath?.path == installPath.value);
  }

  void save(){
    AppState.customGame.value = [
      ...AppState.customGame.value,
      Game(
        launcherChannel: LauncherChannel.unknown,
        launcherPath: Path(launcherPath.value!),
        launcherName: controller.text,
        installPath: Path(installPath.value!),
      ),
    ];
  }

  void onSave(){
    if(verify()){
      final String info = context.tr("gameAlreadyExists");
      if(isExistSame() && errorInfo.value != info){
        errorInfo.value = info;
      }else{
        save();
        Navigator.of(context).pop();
      }
    }else{
      errorInfo.value = context.tr("toLocateGame");
    }
  }

  @override
  Widget build(BuildContext context){
    final Widget locateButton = SmallButton(
      padding: const EdgeInsets.symmetric(horizontal: smallPadding, vertical: 2 * smallPadding),
      width: null,
      height: null,
      colorRole: ColorRoles.background,
      onClick: () async{
        try{
          final FilePickerResult? location = await FilePicker.platform.pickFiles(
            dialogTitle: context.tr("locateInfinityNikki"),
            lockParentWindow: true,
            type: FileType.custom,
            allowedExtensions: ["exe"],
          );

          if(location != null) isAlreadyLocate.value = true;

          if(location != null && location.files.first.path != null){
            final Map<String, Path?> paths = await locateByExePath(Path(location.files.first.path!));

            launcherPath.value = paths["launcherPath"]?.path;
            installPath.value = paths["installPath"]?.path;

            if(launcherPath.value != null && installPath.value == null){
              final installLocation = await FilePicker.platform.getDirectoryPath(
                dialogTitle: context.tr("locateX6GameDir"),
                lockParentWindow: true,
              );

              if(installLocation != null && installLocation.contains("X6Game")){
                installPath.value = installLocation.split("X6Game").first;
              }
            }
          }
        }catch(e){
          final String error = e.toString();
          errorInfo.value = error;
          AppState.writeError("frame.CustomAccountDialog.locateButton", error);
        }
      },
      child: MultiValueListenableBuilder(
        listenables: [launcherPath, installPath, isAlreadyLocate],
        builder: (BuildContext context, List<Object?> values){
          final String? launcher = values[0] as String?;
          final String? install = values[1] as String?;

          return Column(
            children: [
              Row(
                spacing: listSpacing,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.tr("locateGame"), style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                  if(verify()) Image.asset("assets/icon/tick.webp", height: smallButtonContentSize, color: AppTheme.of(context)!.colorScheme.success.pressedColor),
                ],
              ),
              if(isAlreadyLocate.value && launcher == null)
                Row(
                  spacing: listSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.tr("launcherDir"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                    Image.asset("assets/icon/cross.webp", height: smallButtonContentSize, color: AppTheme.of(context)!.colorScheme.error.pressedColor),
                  ],
                ),
              if(isAlreadyLocate.value && launcher == null) Text("(${context.tr("locateInfinityNikki")})", style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
              if(launcher != null) Text("${context.tr("launcherDir")}: $launcher", style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
              if(launcher != null && install == null)
                Row(
                  spacing: listSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.tr("installDir"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                    Image.asset("assets/icon/cross.webp", height: smallButtonContentSize, color: AppTheme.of(context)!.colorScheme.error.pressedColor),
                    Text("(${context.tr("locateX6GameDir")})", style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                  ],
                ),
              if(install != null) Text("${context.tr("installDir")}: $install", style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            ],
          );
        },
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: Column(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            RTextFiled(
              controller: controller,
              labelText: context.tr("name"),
              colorRole: ColorRoles.background,
            ),

            locateButton,

            Row(
              spacing: listSpacing,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// cancel button
                Expanded(
                  child: SmallButton(
                    width: null,
                    colorRole: ColorRoles.background,
                    onClick: () => Navigator.of(context).pop(),
                    child: Text(context.tr("cancel"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),
                ),
                /// save button
                Expanded(
                  child: SmallButton(
                    width: null,
                    colorRole: ColorRoles.background,
                    onClick: onSave,
                    child: Text(context.tr("save"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),
                ),
              ],
            ),

            /// error text
            ValueListenableBuilder(
              valueListenable: errorInfo,
              builder: (BuildContext context, String? info, Widget? child){
                if(info == null) return block0;

                return Text(info, style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor));
              },
            )
          ],
        ),
      ),
    );
  }
}



/////////////////////
//     Content     //
/////////////////////
class ContentItem{
  final int? expectedPosition;
  final String name;
  final ImageProvider icon;
  final Widget page;

  const ContentItem({
    this.expectedPosition,
    required this.name,
    required this.icon,
    required this.page,
  });
}

class ContentController extends ChangeNotifier{
  int counter = 0;
  final Map<int, ContentItem> _items = {};

  int addItem(ContentItem item){
    notifyListeners();
    counter++;
    _items[counter] = item;
    return counter;
  }

  void removeItem(ContentItem match){
    notifyListeners();
    _items.removeWhere((int id, ContentItem item) => match == item);
  }

  void removeItemById(int id){
    notifyListeners();
    if(_items.containsKey(id)) _items.remove(id);
  }

  List<ContentItem> get items{
    final List<MapEntry<int, ContentItem>> entries = _items.entries.toList();

    // 先按 expectedPosition 排，没给位置(null)的统一放最后
    entries.sort((a, b){
      final int? posA = a.value.expectedPosition;
      final int? posB = b.value.expectedPosition;
      if(posA == null && posB == null) return 0;
      if(posA == null) return 1;
      if(posB == null) return -1;
      return posA.compareTo(posB);
    });

    return entries.map<MapEntry<int, ContentItem>>((e) => e).toList()
      .map<ContentItem>((e) => e.value)
      .toList();
  }

  int get length => _items.length;
}

class Content extends StatefulWidget{
  final ContentController controller;

  const Content({
    super.key,
    required this.controller,
  });

  @override
  State<Content> createState() => _ContentState();
}
class _ContentState extends State<Content>{
  final PageController controller = PageController(initialPage: 1);
  List<ContentItem> items = [];

  void updateItemList(){
    items = widget.controller.items;
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();
    widget.controller.addListener(updateItemList);
    updateItemList();
  }

  @override
  void dispose(){
    super.dispose();
    widget.controller.removeListener(updateItemList);
  }

  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        Container(
          width: sideBarWidth,
          color: AppTheme.of(context)!.colorScheme.primary.color,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: items.length,
                  itemExtent: mediumButtonSize,
                  itemBuilder: (BuildContext context, int index){
                    return Center(
                      child: SmallButton(
                        width: mediumButtonSize,
                        height: mediumButtonSize,
                        onClick: (){
                          controller.animateToPage(index, duration: Duration(milliseconds: AppState.animationDuration.value), curve: Curves.easeIn);
                        },
                        child: Image(image: items[index].icon, height: smallButtonSize - 10, color: AppTheme.of(context)!.colorScheme.primary.onColor,),
                      ),
                    );
                  },
                ),
              ),
              /// setting
              SmallButton(
                margin: const EdgeInsets.only(bottom: listSpacing),
                onClick: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return SettingDialog();
                    }
                  );
                },
                child: Image.asset("assets/icon/setting.webp", height: 26, color: AppTheme.of(context)!.colorScheme.primary.onColor,),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppTheme.of(context)!.colorScheme.background.color,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index){
                return KeepAliveWrapper(child: items[index].page);
              },
            ),
          ),
        ),
      ],
    );
  }
}