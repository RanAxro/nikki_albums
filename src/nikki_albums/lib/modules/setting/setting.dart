import "package:flutter/foundation.dart";

import "personalization.dart";
import "edit_custom_game.dart";
import "exporting_image/presentation/exporting_image_setting.dart";
import "nikkias_setting/presentation/nikkias_setting.dart";
import "version_information/presentation/version_information.dart";
import "app_storage/presentation/app_storage.dart";
import "error_log/presentation/error_log.dart";
import "debug_panel/presentation/debug_panel.dart";

import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "dart:io";
import "package:flutter/material.dart";

enum SettingPage {
  personalization,
  accountManagement,
  exportingImageSetting,
  nikkiasSetting,
  versionInformation,
  appStorage,
  errorLog,
  debugPanel,
}

class SettingDialog extends StatelessWidget {
  static bool _isOpen = false;

  static Future<void> show(BuildContext context, {SettingPage initialPage = SettingPage.personalization}) async{
    if(_isOpen) return;
    _isOpen = true;
    try{
      await showAppDialog(
        context: context,
        builder: (BuildContext context) {
          return SettingDialog(initialPage: initialPage);
        },
      );
    }finally{
      _isOpen = false;
    }
  }

  static List<SettingPage> _getActivePages() {
    return [
      SettingPage.personalization,
      if (Platform.isWindows) SettingPage.accountManagement,
      SettingPage.exportingImageSetting,
      SettingPage.nikkiasSetting,
      SettingPage.versionInformation,
      SettingPage.appStorage,
      SettingPage.errorLog,
      if (kDebugMode) SettingPage.debugPanel,
    ];
  }

  static int _getInitialIndex(SettingPage page) {
    int index = _getActivePages().indexOf(page);
    return index == -1 ? 0 : index;
  }


  final SettingPage initialPage;
  final PageController controller;
  final List<SettingPage> activePages;

  SettingDialog({super.key, this.initialPage = SettingPage.personalization})
    : activePages = _getActivePages(),
      controller = PageController(initialPage: _getInitialIndex(initialPage));

  SettingPage? _getCurrentPages() {
    if(!controller.hasClients){
      return null;
    }

    final int? index = controller.page?.toInt();

    if(index == null){
      return null;
    }

    return _getActivePages()[index];
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: listSpacing,
      children: [
        SizedBox(
          width: sideBarExpandWidth,
          child: SmoothPointerScroll(
            builder:
                (
                  BuildContext context,
                  ScrollController scrollController,
                  ScrollPhysics physics,
                  IndependentScrollbarController scrollbarController,
                ) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          return ListenableBuilder(
                            listenable: controller,
                            builder: (BuildContext context, Widget? child) {
                              return AppRadioStack(
                                direction: Axis.vertical,
                                selectedIndex:
                                    controller.page?.toInt() ??
                                    _getInitialIndex(initialPage),
                                children: activePages.map((page) {
                                  String title = "";
                                  switch (page) {
                                    case SettingPage.personalization:
                                      title = "personalization";
                                      break;
                                    case SettingPage.accountManagement:
                                      title = "accountManagement";
                                      break;
                                    case SettingPage.exportingImageSetting:
                                      title = "exporting_image_setting.setting_name";
                                      break;
                                    case SettingPage.nikkiasSetting:
                                      title = "nikkias_setting";
                                      break;
                                    case SettingPage.versionInformation:
                                      title = "version_information";
                                      break;
                                    case SettingPage.appStorage:
                                      title = "app_storage.name";
                                      break;
                                    case SettingPage.errorLog:
                                      title = "error_log";
                                      break;
                                    case SettingPage.debugPanel:
                                      title = "Debug Panel";
                                      break;
                                  }
                                  return AppButton.smallText(
                                    width: constraints.maxWidth,
                                    height: smallButtonSize,
                                    onClick: () {
                                      controller.jumpToPage(
                                        activePages.indexOf(page),
                                      );
                                    },
                                    child: AppText(
                                      title,
                                      isTranslate: page != SettingPage.debugPanel,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                  );
                },
          ),
        ),

        AppDivider(direction: Axis.vertical),

        Expanded(
          child: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: activePages.map((page) {
              Widget pageWidget;
              switch (page) {
                case SettingPage.personalization:
                  pageWidget = const Personalization();
                  break;
                case SettingPage.accountManagement:
                  pageWidget = const EditCustomGame();
                  break;
                case SettingPage.exportingImageSetting:
                  pageWidget = const ExportingImageSetting();
                  break;
                case SettingPage.nikkiasSetting:
                  pageWidget = const NikkiasSetting();
                  break;
                case SettingPage.versionInformation:
                  pageWidget = const VersionInformation();
                  break;
                case SettingPage.appStorage:
                  pageWidget = const AppStorage();
                  break;
                case SettingPage.errorLog:
                  pageWidget = const ErrorLog();
                  break;
                case SettingPage.debugPanel:
                  pageWidget = const DebugPanel();
                  break;
              }
              return FadeIn(
                offsetBegin: Offset.zero,
                opacityBegin: 0.0,
                child: pageWidget,
              );
            }).toList(),
          ),
        ),
      ],
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child){
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return AnimatedContainer(
                duration: animationTime,
                padding: const EdgeInsets.all(smallPadding),
                width: (_getCurrentPages() ?? initialPage) == SettingPage.debugPanel
                        || (_getCurrentPages() ?? initialPage) == SettingPage.errorLog
                    ? constraints.maxWidth - 88
                    : 700,
                child: child,
              );
            },
          );
        },
        child: AppFloatingIndicatorButtonGroup(
          child: Column(
            spacing: bigListSpacing,
            children: [
              SizedBox(
                height: topBarHeight,
                child: Row(
                  spacing: bigListSpacing,
                  children: [
                    block10W,
                    Expanded(
                      child: AppText.tr(
                        "setting",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    AppFloatingIndicatorButtonTarget(
                      child: const ChangeLanguage(),
                    ),

                    AppFloatingIndicatorButtonTarget(
                      child: AppButton.smallIcon(
                        colorRole: ColorRole.background,
                        onClick: () {
                          Navigator.of(context).pop();
                        },
                        child: AppIcon("cross", height: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: smallCardMaxHeight,
      child: Row(
        spacing: bigListSpacing,
        children: [
          Align(alignment: Alignment.topCenter, child: AppText.tr("theme")),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: smallButtonContentSize,
                mainAxisSpacing: listSpacing,
                crossAxisSpacing: listSpacing,
                childAspectRatio: 1 / 1,
              ),
              itemCount: AppColorScheme.table.length,
              itemBuilder: (BuildContext context, int index) {
                final int color = AppColorScheme.table.keys.toList(
                  growable: false,
                )[index];
                return GestureDetector(
                  onTap: () {
                    AppState.theme.value = color;
                  },
                  child: ClipOval(child: Container(color: Color(color))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeLanguage extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    MenuController controller,
    Widget? child,
  )?
  builder;

  const ChangeLanguage({super.key, this.builder});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppTheme.of(context)!.colorScheme.background.color,
        ),
      ),
      menuChildren: [
        for (final entry in const [
          ("zh-CN", "简体中文"),
          ("zh-TW", "繁體中文"),
          ("en-US", "English"),
          ("ja-JP", "日本語"),
          ("ko-KR", "한국어"),
          ("fr-FR", "Français"),
          ("de-DE", "Deutsch"),
          ("es-ES", "Español"),
          ("pt-BR", "Português"),
          ("it-IT", "Italiano"),
          ("id-ID", "Bahasa Indonesia"),
          ("th-TH", "ภาษาไทย"),
        ])
          MenuItemButton(
            onPressed: () {
              AppState.lang.value = entry.$1;
            },
            child: AppText(entry.$2),
          ),
      ],
      builder:
          builder ??
          (BuildContext context, MenuController controller, Widget? child) {
            return AppButton.smallText(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              width: null,
              colorRole: ColorRole.background,
              onClick: () {
                controller.isOpen ? controller.close() : controller.open();
              },
              child: Row(
                spacing: listSpacing,
                children: [
                  AppIcon("language", height: 16),
                  AppText.tr("language"),
                  AppText.tr("lang"),
                ],
              ),
            );
          },
    );
  }
}
