import "package:nikki_albums/modules/hot_update/domain/check_app_hot_updates.dart";
import "package:nikki_albums/modules/initial_startup/presentation/initial_startup_setting.dart";

import "package:nikki_albums/modules/app_base/app_registry.dart";
import "package:nikki_albums/utils/system/windows.dart";
import "package:nikki_albums/modules/setting/version_information/domain/check_app_updates.dart";
import "ui_android.dart";

import "package:nikki_albums/modules/game/uid.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/nikkias/nikkias.dart";
import "package:nikki_albums/modules/setting/setting.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/modules/game/game.dart";
import "package:nikki_albums/utils/path.dart";

import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

import "package:window_manager/window_manager.dart";
import "package:desktop_drop/desktop_drop.dart";
import "package:file_picker/file_picker.dart";
import "package:nikki_albums/utils/native_file_picker.dart";
import "package:easy_localization/easy_localization.dart";

class Frame extends StatefulWidget {
  const Frame(key) : super(key: key);

  GlobalKey get globalKey => key as GlobalKey;

  @override
  State<StatefulWidget> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  void whenLangChanged() {
    final List lang = AppState.lang.value.split("-");
    widget.globalKey.currentContext?.setLocale(Locale(lang[0], lang[1]));
  }

  void whenThemeChanged() {
    setState(() {});
  }
  
  Future<void> checkHotUpdate(BuildContext context) async{
    try{
      final bool needNotice = await checkAppHotUpdates();
      if(!needNotice) return;

      if(context.mounted){
        final List lang = AppState.lang.value.split("-");
        await EasyLocalization.of(context)?.delegate.load(Locale(lang[0], lang[1]));
        await EasyLocalization.of(context)?.resetLocale();

        setState((){
          AppToast.showMessage(context: context, message: context.tr("hot_update_successful"));
        });
      }
    }catch(e){
      if(context.mounted){
        AppToast.showMessage(
          context: context,
          message: context.tr("hot_update_failed!\n$e"),
          state: false,
        );
      }
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final isMac = Platform.isMacOS;
      final isCmd = HardwareKeyboard.instance.isMetaPressed;
      final isCtrl = HardwareKeyboard.instance.isControlPressed;
      final isComma = event.logicalKey == LogicalKeyboardKey.comma;

      if (isComma && ((isMac && isCmd) || (!isMac && isCtrl))) {
        if (mounted && frameKey.currentContext != null) {
          SettingDialog.show(
            frameKey.currentContext!,
            initialPage: SettingPage.personalization,
          );
          return true; // handled
        }
      }
    }
    return false; // not handled
  }

  @override
  void initState() {
    super.initState();
    AppState.lang.addListener(whenLangChanged);
    AppState.theme.addListener(whenThemeChanged);
    AppState.isThemeFollowSystem.addListener(whenThemeChanged);
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.fromView(
      view: View.of(context),
      child: Builder(
        builder: (context) {
          int currentTheme = AppState.theme.value;
          if (AppState.isThemeFollowSystem.value) {
            final Brightness brightness = MediaQuery.platformBrightnessOf(
              context,
            );
            if (brightness == Brightness.dark) {
              currentTheme = 0xFF333333; // Dark theme
            } else {
              currentTheme = (currentTheme == 0xFF333333)
                  ? 0xFFEEEEEE
                  : currentTheme;
            }
          }

          /// 加载语言
          final List lang = AppState.lang.value.split("-");
          context.setLocale(Locale(lang[0], lang[1]));

          return AppTheme(
            theme: currentTheme,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: Scaffold(
                body: ValueListenableBuilder(
                  valueListenable: AppState.isInitialStartup,
                  builder: (BuildContext context, bool value, Widget? child) {
                    /// 首次使用软件
                    if (value) {
                      return InitialStartupSetting();
                    }

                    /// TODO check
                    if (!kDebugMode) {
                      checkAppUpdates(context);
                    }
                    /// 热更新
                    checkHotUpdate(context);

                    if (Platform.isWindows) {
                      return WindowsFrame(key: frameKey);
                    } else if (Platform.isAndroid) {
                      return AndroidFrame(key: frameKey);
                    } else if (Platform.isMacOS) {
                      return MacOSFrame(key: frameKey);
                    } else {
                      return const Placeholder();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
    AppState.lang.removeListener(whenLangChanged);
    AppState.theme.removeListener(whenThemeChanged);
    AppState.isThemeFollowSystem.removeListener(whenThemeChanged);
  }
}

class AccountButton extends StatelessWidget {
  const AccountButton({super.key});

  Row _itemButton({
    required BuildContext context,
    ImageProvider? image,
    required String text,
  }) {
    return Row(
      spacing: listSpacing,
      children: [
        image == null
            ? block0
            : Image(image: image, height: smallButtonSize - 10),
        AppText(text),
      ],
    );
  }

  RFutureBuilder<List<Uid>> _itemBuilder(Game game) {
    return RFutureBuilder<List<Uid>>(
      future: game.findUid(),
      builder: (BuildContext context, List<Uid> uidList) {
        if (uidList.isEmpty) {
          return MenuItemButton(
            onPressed: () {
              game.selectedUid = null;
              AppState.currentGame.value = game;
            },
            child: _itemButton(
              context: context,
              image: game.logoImage,
              text: game.name,
            ),
          );
        }
        return SubmenuButton(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              AppTheme.of(context)!.colorScheme.background.color,
            ),
          ),
          menuChildren: List.generate(uidList.length, (int index) {
            final Uid uid = uidList[index];
            return MenuItemButton(
              onPressed: () {
                game.selectedUid = uid;
                AppState.currentGame.value = game;
              },
              child: RFutureBuilder(
                future: uid.avatarImage,
                waitingBuilder: (BuildContext context, Widget indicator) {
                  return _itemButton(context: context, text: uid.name);
                },
                builder: (BuildContext context, avatar) {
                  return _itemButton(
                    context: context,
                    image: avatar == null ? null : FileImage(avatar.file),
                    text: uid.name,
                  );
                },
              ),
            );
          }),
          child: _itemButton(
            context: context,
            image: game.logoImage,
            text: game.name,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// menu
    return ValueListenableBuilder(
      valueListenable: AppState.customGame,
      builder: (BuildContext context, List<Game> customGame, Widget? child) {
        final List<Widget> menuChildren = <Widget>[];

        /// find Game from device
        menuChildren.add(
          RFutureBuilder<List<Game>>(
            future: FindGame.find(),
            builder: (BuildContext context, List<Game> gameList) {
              return Column(
                children: List.generate(
                  gameList.length,
                  (int index) => _itemBuilder(gameList[index]),
                ),
              );
            },
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
        if (Platform.isWindows) {
          menuChildren.add(
            MenuItemButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAccountEditor(),
                );
              },
              child: AppText.tr("addCustomAccountButton"),
            ),
          );
        }

        return MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              AppTheme.of(context)!.colorScheme.background.color,
            ),
          ),
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
                return GestureDetector(
                  onSecondaryTap: () {
                    if (AppState.currentGame.value?.selectedUid == null) return;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UidNoteEditor(
                          AppState.currentGame.value!.selectedUid!,
                        );
                      },
                    );
                  },
                  child: AppButton.smallIcon(
                    padding: const EdgeInsets.all(listSpacing),
                    width: null,
                    colorRole: ColorRole.secondary,
                    useConfiguration: false,
                    isTransparent: false,
                    onClick: () {
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                    child: child,
                  ),
                );
              },
          menuChildren: menuChildren,
          child: child,
        );
      },

      /// button content
      child: ValueListenableBuilder<Game?>(
        valueListenable: AppState.currentGame,
        builder: (BuildContext context, Game? currentGame, Widget? child) {
          if (currentGame == null) {
            return Row(
              spacing: listSpacing,
              children: [
                AppIcon("select", height: smallButtonSize - 10),
                AppText.tr("selectAccountButton"),
              ],
            );
          }

          return ListenableBuilder(
            listenable: currentGame,
            builder: (BuildContext context, Widget? child) {
              return Row(
                spacing: listSpacing,
                children: [
                  RFutureBuilder(
                    future: currentGame.selectedUid?.avatarImage,
                    builder: (BuildContext context, FileImage? image) {
                      return Image(image: image ?? currentGame.logoImage);
                    },
                  ),

                  /// launcher name/uid text
                  ValueListenableBuilder(
                    valueListenable: AppState.uidNotes,
                    builder:
                        (
                          BuildContext context,
                          Set<UidNote> notes,
                          Widget? child,
                        ) {
                          return AppText(
                            currentGame.selectedUid?.name ??
                                currentGame.launcherChannel.name,
                          );
                        },
                  ),

                  /// nail button
                  ValueListenableBuilder(
                    valueListenable: AppState.gameShortcuts,
                    builder:
                        (
                          BuildContext context,
                          Set<GameShortcut> shortcuts,
                          Widget? child,
                        ) {
                          if (AppState.currentGame.value == null ||
                              AppState.currentGame.value!.selectedUid == null) {
                            return block0;
                          }

                          final Game game = AppState.currentGame.value!;
                          final GameShortcut shortcut = game.shortcut!;
                          final bool isNailed = shortcut.isNailed;
                          final String icon = isNailed ? "nail_fill" : "nail";

                          return AppButton.smallIcon(
                            colorRole: ColorRole.secondary,
                            onClick: () {
                              isNailed ? shortcut.remove() : shortcut.add();
                            },
                            child: AppIcon(icon, height: 20),
                          );
                        },
                  ),
                ],
              );
            },
          );
        },
      ),
    );

    // return Expanded(
    //   child: Align(
    //     alignment: Alignment.centerLeft,
    //     child: UnconstrainedBox(
    //       child: menu,
    //     ),
    //   ),
    // );
  }
}

class CustomAccountEditor extends StatefulWidget {
  const CustomAccountEditor({super.key});

  @override
  State<CustomAccountEditor> createState() => _CustomAccountEditorState();
}

class _CustomAccountEditorState extends State<CustomAccountEditor> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> isAlreadyLocate = ValueNotifier<bool>(false);
  final ValueNotifier<String?> launcherPath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> installPath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> errorInfo = ValueNotifier<String?>(null);

  bool verify() => launcherPath.value != null && installPath.value != null;

  bool isExistSame() {
    final List<Game> existingGame = [];
    if (Game.cacheGameList != null) existingGame.addAll(Game.cacheGameList!);
    existingGame.addAll(AppState.customGame.value);

    return existingGame.any(
      (game) =>
          game.launcherPath.path == launcherPath.value &&
          game.installPath.path == installPath.value,
    );
  }

  void save() {
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

  void onSave() {
    if (verify()) {
      final String info = context.tr("gameAlreadyExists");
      if (isExistSame() && errorInfo.value != info) {
        errorInfo.value = info;
      } else {
        save();
        Navigator.of(context).pop();
      }
    } else {
      errorInfo.value = context.tr("toLocateGame");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget locateButton = AppButton(
      borderRadius: smallBorderRadius,
      padding: const EdgeInsets.symmetric(
        horizontal: smallPadding,
        vertical: 2 * smallPadding,
      ),
      colorRole: ColorRole.background,
      isTransparent: false,
      onClick: () async {
        try {
          final FilePickerResult? location = await FilePicker.platform
              .pickFiles(
                dialogTitle: context.tr("locateInfinityNikki"),
                lockParentWindow: true,
                type: FileType.custom,
                allowedExtensions: ["exe"],
              );

          if (location != null) isAlreadyLocate.value = true;

          if (location != null && location.files.first.path != null) {
            final Map<String, Path?> paths = await locateByExePath(
              Path(location.files.first.path!),
            );

            launcherPath.value = paths["launcherPath"]?.path;
            installPath.value = paths["installPath"]?.path;

            if (launcherPath.value != null && installPath.value == null) {
              final installLocation = await NativeFilePicker.getDirectoryPath(
                dialogTitle: context.tr("locateX6GameDir"),
                lockParentWindow: true,
              );

              if (installLocation != null &&
                  installLocation.contains("X6Game")) {
                installPath.value = installLocation.split("X6Game").first;
              }
            }
          }
        } catch (e) {
          final String error = e.toString();
          errorInfo.value = error;
          AppState.writeError("frame.CustomAccountDialog.locateButton", error);
        }
      },
      child: MultiValueListenableBuilder(
        listenables: [launcherPath, installPath, isAlreadyLocate],
        builder: (BuildContext context, Widget? child) {
          final String? launcher = launcherPath.value;
          final String? install = installPath.value;

          return Column(
            children: [
              Row(
                spacing: listSpacing,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.tr("locateGame"),
                  if (verify()) AppIcon("tick", height: smallButtonContentSize),
                ],
              ),
              if (isAlreadyLocate.value && launcher == null)
                Row(
                  spacing: listSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.tr("launcherDir"),
                    AppIcon("cross", height: smallButtonContentSize),
                  ],
                ),
              if (isAlreadyLocate.value && launcher == null)
                AppText("(${context.tr("locateInfinityNikki")})"),
              if (launcher != null)
                AppText("${context.tr("launcherDir")}: $launcher"),
              if (launcher != null && install == null)
                Row(
                  spacing: listSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.tr("installDir"),
                    AppIcon("cross", height: smallButtonContentSize),
                    AppText("(${context.tr("locateX6GameDir")})"),
                  ],
                ),
              if (install != null)
                AppText("${context.tr("installDir")}: $install"),
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
            AppTextFiled(controller: controller, labelText: "name"),

            locateButton,

            block5H,

            Row(
              spacing: listSpacing,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// cancel button
                Expanded(
                  child: AppButton.smallText(
                    colorRole: ColorRole.background,
                    onClick: () => Navigator.of(context).pop(),
                    child: AppText.tr("cancel"),
                  ),
                ),

                /// save button
                Expanded(
                  child: AppButton.smallText(
                    colorRole: ColorRole.highlight,
                    isTransparent: false,
                    onClick: onSave,
                    child: AppText.tr("save"),
                  ),
                ),
              ],
            ),

            /// error text
            ValueListenableBuilder(
              valueListenable: errorInfo,
              builder: (BuildContext context, String? info, Widget? child) {
                if (info == null) return block0;

                return Text(
                  info,
                  style: TextStyle(
                    color: AppTheme.of(context)!.colorScheme.error.pressedColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// TODO 拖动排序功能
class GameShortcutBar extends StatelessWidget {
  const GameShortcutBar({super.key});

  Widget _generateMoreMenu(
    BuildContext context,
    GameShortcut shortcut,
    ValueNotifier<bool> hover,
  ) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppTheme.of(context)!.colorScheme.background.color,
        ),
      ),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: hover,
              builder: (BuildContext context, bool isHover, Widget? child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: isHover ? smallButtonSize : 0,
                  child: AppButton.smallIcon(
                    colorRole: ColorRole.secondary,
                    onClick: () {
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                    child: AppIcon("more", height: 16),
                  ),
                );
              },
            );
          },
      menuChildren: [
        /// remarks button
        MenuItemButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UidNoteEditor(shortcut.selectedUid);
              },
            );
          },
          child: Row(
            spacing: listSpacing,
            children: [AppIcon("edit", height: 16), AppText.tr("remarks")],
          ),
        ),

        /// remove shortcut button
        MenuItemButton(
          onPressed: () {
            shortcut.remove();
          },
          child: Row(
            spacing: listSpacing,
            children: [
              Image.asset(
                "assets/icon/cross.webp",
                height: 16,
                color: AppTheme.of(
                  context,
                )!.colorScheme.background.onEnabledColor,
              ),
              AppText.tr("delete"),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _generateChildren(
    BuildContext context,
    Set<GameShortcut> shortcuts,
  ) {
    return shortcuts.map<Widget>((GameShortcut shortcut) {
      final Game game = shortcut.game;
      final ValueNotifier<bool> hover = ValueNotifier<bool>(false);

      return MouseRegion(
        onEnter: (_) {
          hover.value = true;
        },
        onExit: (_) {
          hover.value = false;
        },
        child: AppButton.smallText(
          padding: const EdgeInsets.fromLTRB(
            smallPadding,
            smallPadding,
            0,
            smallPadding,
          ),
          colorRole: ColorRole.secondary,
          onClick: () {
            AppState.currentGame.value = game;
          },
          child: Row(
            spacing: listSpacing,
            children: [
              RFutureBuilder(
                future: shortcut.selectedUid.avatarImage,
                builder: (BuildContext context, FileImage? image) {
                  return Image(image: image ?? game.logoImage);
                },
              ),

              ValueListenableBuilder(
                valueListenable: AppState.uidNotes,
                builder:
                    (BuildContext context, Set<UidNote> notes, Widget? child) {
                      return AppText(shortcut.selectedUid.name);
                    },
              ),

              _generateMoreMenu(context, shortcut, hover),
            ],
          ),
        ),
      );
    }).toList()..add(
      /// TODO 触发滚轮事件时, hover状态会被中断. 最后一个shortcut会抽搐
      /// 在按钮末尾留出空间, 防止点不到关闭
      SizedBox(width: smallButtonSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: bigPadding),
          child: SmoothPointerScroll(
            builder:
                (
                  BuildContext context,
                  ScrollController controller,
                  ScrollPhysics physics,
                  IndependentScrollbarController scrollbarController,
                ) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    physics: physics,
                    child: ValueListenableBuilder(
                      valueListenable: AppState.gameShortcuts,
                      builder:
                          (
                            BuildContext context,
                            Set<GameShortcut> shortcuts,
                            Widget? child,
                          ) {
                            return Row(
                              children: _generateChildren(context, shortcuts),
                            );
                          },
                    ),
                  );
                },
          ),
        ),
      ),
    );
  }
}

class UidNoteEditor extends StatelessWidget {
  final Uid uid;
  const UidNoteEditor(this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: uid.note,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        width: smallDialogMaxWidth,
        child: Column(
          spacing: smallPadding,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(context.tr("noteXAs", args: [uid.value])),

            AppTextFiled(controller: controller, labelText: "fillRemarks"),

            AppButton.smallText(
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: () {
                Navigator.of(context).pop();
              },
              child: AppText.tr("cancel"),
            ),
            AppButton.smallText(
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: () {
                uid.note = controller.text == "" ? null : controller.text;
                Navigator.of(context).pop();
              },
              child: AppText.tr("save"),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////
//     Content     //
/////////////////////
class ContentItem {
  final String name;
  final AppIcon icon;
  final Widget page;
  final bool isKeepAlive;
  final int supportedPlatforms;

  const ContentItem({
    required this.name,
    required this.icon,
    required this.page,
    this.isKeepAlive = true,
    this.supportedPlatforms = inAllPlatforms,
  });
}

class ContentController extends ChangeNotifier {
  int _index;
  final PageController pageController;

  ContentController(this._index)
    : pageController = PageController(initialPage: _index);

  int get index => _index;

  set index(int newIndex) {
    if (newIndex != _index) {
      _index = newIndex;
      pageController.jumpToPage(_index);
      notifyListeners();
    }
  }
}

class ContentBuilder extends StatelessWidget {
  final Axis direction;
  final Widget Function(BuildContext context, List<(String name, AppIcon icon)>)
  navBuilder;
  final Widget Function(BuildContext context, List<Widget>) pageBuilder;

  const ContentBuilder({
    super.key,
    required this.direction,
    required this.navBuilder,
    required this.pageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      navBuilder(
        context,
        AppRegistry.homeContent
            .map((ContentItem item) => (item.name, item.icon))
            .toList(growable: false),
      ),

      Expanded(
        child: pageBuilder(
          context,
          AppRegistry.homeContent
              .map(
                (ContentItem item) => KeepAliveWrapper(
                  keepAlive: item.isKeepAlive,
                  child: item.page,
                ),
              )
              .toList(growable: false),
        ),
      ),
    ];

    return direction == Axis.horizontal
        ? Row(children: children)
        : Column(children: children);
  }
}

/////////////////////
//     Windows     //
/////////////////////
class WindowsFrame extends StatelessWidget {
  const WindowsFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails details) {
        final Path path = Path(details.files.first.path);
        parseNikkiasFile(context, path.file);

        /// TODO 将窗口提前
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const WindowTitleBar(),
            Expanded(child: ContentBuildInWindow()),
          ],
        ),
      ),
    );
  }
}

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      colorRole: ColorRole.secondary,
      child: SizedBox(
        height: windowTitleBarHeight,
        child: Stack(
          children: [
            Positioned.fill(child: DragToMoveArea(child: Container())),
            Row(
              children: [
                /// Icon
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

                const GameShortcutBar(),

                /// top window button
                AppUncontrolledSwitch(
                  width: smallButtonSize,
                  height: smallButtonSize,
                  onChanged: doTopWindow,
                  child: AppIcon("top", height: 20),
                ),

                block5W,

                if (kDebugMode)
                  AppButton.smallText(
                    colorRole: ColorRole.background,
                    isTransparent: false,
                    onClick: () {
                      SettingDialog.show(
                        context,
                        initialPage: SettingPage.debugPanel,
                      );
                    },
                    child: Row(
                      spacing: listSpacing,
                      children: [
                        Icon(
                          Icons.bug_report_outlined,
                          color: AppColorScheme.of(context).background.onColor,
                        ),
                        AppText("Debug Panel", isTranslate: false),
                      ],
                    ),
                  ),

                /// minimize window button
                AppButton(
                  width: windowTitleBarHeight + 10,
                  height: windowTitleBarHeight,
                  onClick: () async {
                    await windowManager.minimize();
                  },
                  child: AppIcon("minimize", height: 14),
                ),

                /// maximizeOrRestore button
                ValueListenableBuilder(
                  valueListenable: AppState.isUseMaximizeOrRestoreButton,
                  builder:
                      (
                        BuildContext context,
                        bool isUseMaximizeOrRestoreButton,
                        Widget? child,
                      ) {
                        return AppButton(
                          width: isUseMaximizeOrRestoreButton
                              ? windowTitleBarHeight + 10
                              : 0,
                          height: windowTitleBarHeight,
                          onClick: () async {
                            if (await windowManager.isMaximized()) {
                              await windowManager.unmaximize();
                            } else {
                              await windowManager.maximize();
                            }
                          },
                          child: AppIcon("maximizeOrRestore", height: 16),
                        );
                      },
                ),

                /// close window button
                AppButton(
                  width: windowTitleBarHeight + 10,
                  height: windowTitleBarHeight,
                  colorRole: ColorRole.error,
                  onClick: closeApp,
                  child: AppIcon("cross", height: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContentBuildInWindow extends StatelessWidget {
  const ContentBuildInWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBuilder(
      direction: Axis.horizontal,
      navBuilder: (BuildContext context, List<(String, AppIcon)> navInfo) {
        final Widget navButton = Expanded(
          child: ListenableBuilder(
            listenable: contentController,
            builder: (BuildContext context, Widget? child) {
              return AppRadioStack(
                direction: Axis.vertical,
                buttonWidth: mediumButtonSize,
                buttonHeight: mediumButtonSize,
                selectedIndex: contentController.index,
                children: [
                  for (final (index, info) in navInfo.indexed)
                    AppRawButton(
                      onClick: () {
                        contentController.index = index;
                      },
                      child: info.$2,
                    ),
                ],
              );
            },
          ),
        );

        return AppBackground(
          colorRole: ColorRole.primary,
          child: SizedBox(
            width: sideBarWidth,
            child: Column(
              children: [
                navButton,

                /// setting
                GestureDetector(
                  /// select a nikkias file, and then parse it;
                  onSecondaryTap: () async {
                    final FilePickerResult? location = await FilePicker.platform
                        .pickFiles(
                          dialogTitle: context.tr("selectNikkiasFile"),
                          lockParentWindow: true,
                          type: FileType.custom,
                          allowedExtensions: [nikkiasExtension],
                          allowMultiple: false,
                        );

                    if (location != null) {
                      final String? pathStr = location.paths.firstOrNull;
                      if (pathStr == null) return;

                      if (context.mounted) {
                        parseNikkiasFile(context, File(pathStr));
                      }
                    }
                  },
                  child: AppButton.smallIcon(
                    margin: const EdgeInsets.only(bottom: listSpacing),
                    onClick: () {
                      SettingDialog.show(
                        context,
                        initialPage: SettingPage.personalization,
                      );
                    },
                    child: AppIcon("setting", height: 26),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      pageBuilder: (BuildContext context, List<Widget> pages) {
        return AppBackground(
          colorRole: ColorRole.background,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: contentController.pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              return ListenableBuilder(
                listenable: contentController,
                builder: (BuildContext context, Widget? child) {
                  return FadeIn(
                    offsetBegin: Offset.zero,
                    opacityBegin: 0.0,
                    child: pages[index],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

///////////////////
//     MacOS     //
///////////////////

class MacOSFrame extends StatelessWidget {
  const MacOSFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails details) {
        final Path path = Path(details.files.first.path);
        parseNikkiasFile(context, path.file);

        /// TODO 将窗口提前
      },
      child: Column(
        children: [
          const MacOSTitleBar(),
          Expanded(child: ContentBuildInWindow()),
        ],
      ),
    );
  }
}

class MacOSTitleBar extends StatelessWidget {
  const MacOSTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      colorRole: ColorRole.secondary,
      child: SizedBox(
        height: windowTitleBarHeight,
        child: Stack(
          children: [
            Positioned.fill(child: DragToMoveArea(child: Container())),
            Row(
              children: [
                // Leave space for native traffic light buttons
                SizedBox(width: macOSTrafficLightWidth),

                Expanded(
                  child: Row(
                    children: [const AccountButton(), const GameShortcutBar()],
                  ),
                ),

                if (kDebugMode)
                  AppButton.smallText(
                    colorRole: ColorRole.background,
                    isTransparent: false,
                    onClick: () {
                      SettingDialog.show(
                        context,
                        initialPage: SettingPage.debugPanel,
                      );
                    },
                    child: Row(
                      spacing: listSpacing,
                      children: [
                        Icon(
                          Icons.bug_report_outlined,
                          color: AppColorScheme.of(context).background.onColor,
                        ),
                        AppText("Debug Panel", isTranslate: false),
                      ],
                    ),
                  ),

                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
