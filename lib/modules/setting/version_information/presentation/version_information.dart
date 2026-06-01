
import "update_dialog.dart";
import "../model/update_info.dart";
import "../domain/launch_official_website.dart";
import "../domain/get_update_info.dart";

import "package:nikki_albums/info.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";
import "package:url_launcher/url_launcher.dart";


class VersionInformation extends StatelessWidget{
  const VersionInformation({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: smallDialogMaxWidth,
          child: Column(
            spacing: bigListSpacing,
            children: [
              AppText("${context.tr("version")}: $versionString", isTranslate: false),

              CheckUpdatesButton(),

              SmallButton(
                width: null,
                colorRole: ColorRole.background,
                transparent: false,
                onClick: (){
                  launchOfficialWebsite(context: context);
                },
                child: AppText("toOfficialWebsite"),
              ),

              SmallButton(
                width: null,
                colorRole: ColorRole.background,
                transparent: false,
                onClick: () async{
                  final uri = Uri.parse("https://$githubWebsite");
                  if(await canLaunchUrl(uri)){
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: AppText("toGitHub"),
              ),

              block10H,
              SelectableText(
                context.tr("info"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.background.onColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CheckUpdatesButton extends StatefulWidget{
  const CheckUpdatesButton({super.key});

  @override
  State<CheckUpdatesButton> createState() => _CheckUpdatesButtonState();
}
class _CheckUpdatesButtonState extends State<CheckUpdatesButton>{
  int _checkCount = 1;

  @override
  Widget build(BuildContext context){
    return Column(
      spacing: listSpacing,
      children: [
        SizedBox(
          height: smallButtonSize,
          child: Center(
            child: RFutureBuilder(
          key: ValueKey(_checkCount),
          future: getUpdateInfo(),
          builder: (BuildContext context, UpdateInfo? info){
            if(info == null){
              return AppText("checkFailed");
            }

            if(info.platformVersion <= version){
              return AppText("alreadyTheLatestVersion");
            }

            WidgetsBinding.instance.addPostFrameCallback((_){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UpdateDialog(info: info);
                },
              );
            });

            return AppText("${context.tr("findNewVersion")} ${info.platformVersionString}", isTranslate: false);
          },
        ),
          ),
        ),
        SmallButton(
          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
          colorRole: ColorRole.background,
          transparent: false,
          width: null,
          onClick: (){
            setState((){ _checkCount++; });
          },
          child: AppText("checkForUpdates"),
        ),
      ],
    );
  }
}