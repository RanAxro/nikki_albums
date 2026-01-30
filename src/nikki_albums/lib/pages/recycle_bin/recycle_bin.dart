
import "package:nikkialbums/info.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/utils/system/system.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/utils/quiet_watcher.dart";
import "package:nikkialbums/utils/unit.dart";

import "package:flutter/material.dart";
import "dart:math";
import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";



final ContentItem item = ContentItem(
  expectedPosition: 5,
  name: "recycle_bin",
  icon: AssetImage("assets/icon/recycle_bin.webp"),
  page: const RecycleBin(),
);

void init(){
  pages.addItem(item);
}


class RecycleBin extends StatelessWidget{
  const RecycleBin({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child){
        if(game == null) return block0;

        return RecycleBinBuilder(
          game: game,
          builder: (BuildContext context, Path recycleBinPath, List<DeletionRecord> records, void Function() refresh){
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: smallPadding,
                  vertical: bigPadding,
                ),
                constraints: const BoxConstraints(maxWidth: mediumCardMaxWidth),
                child: Column(
                  spacing: bigPadding,
                  children: [
                    TopBar(recycleBinPath: recycleBinPath, refresh: refresh),
                    Expanded(
                      child: DeletionBox(records),
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



class TopBar extends StatelessWidget{
  final Path recycleBinPath;
  final void Function() refresh;

  const TopBar({
    super.key,
    required this.recycleBinPath,
    required this.refresh,
  });

  void _clearRecycleBin(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
          child: DeleteDirectoryProcessor(
            directory: recycleBinPath.directory,
            safeTimeSecond: 8,
            message: context.tr("clearRecycleBinMessage"),
            onCancel: (){
              Navigator.of(context).pop();
            },
            onFinish: (){
              Navigator.of(context).pop();
            },
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: smallPadding),
      child: Row(
        spacing: listSpacing,
        children: [
          Image.asset("assets/icon/recycle_bin.webp", height: 38, color: AppTheme.of(context)!.colorScheme.background.onEnabledColor),

          Text(context.tr("recycleBin"), style: TextStyle(fontSize: 32, color: AppTheme.of(context)!.colorScheme.background.onColor)),

          RFutureBuilder(
            future: recycleBinPath.size(),
            builder: (BuildContext context, int size){
              return Text(" ( ${formatBytes(size)} ) ", style: TextStyle(fontSize: 26, color: AppTheme.of(context)!.colorScheme.background.onColor));
            },
          ),

          Expanded(child: block0),

          Tooltip(
            message: context.tr("refresh"),
            child: SmallButton(
              colorRole: ColorRoles.background,
              transparent: false,
              onClick: refresh,
              child: Image.asset("assets/icon/refresh.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onEnabledColor),
            ),
          ),

          SmallButton(
            padding: const EdgeInsets.symmetric(horizontal: smallPadding),
            width: null,
            colorRole: ColorRoles.background,
            transparent: false,
            onClick: (){
              _clearRecycleBin(context);
            },
            child: Row(
              spacing: listSpacing,
              children: [
                Image.asset("assets/icon/clear.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onEnabledColor),
                Text(context.tr("clearRecycleBin"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class DeletionBox extends StatelessWidget{
  final List<DeletionRecord> records;

  const DeletionBox(this.records, {super.key});

  Future<void> _restore(BuildContext context, DeletionRecord deletionRecord) async{
    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      barrierDismissible: false,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close){
        if(errorNum == 0){
          WidgetsBinding.instance.addPostFrameCallback((_){
            close();
          });
          return block0;
        }

        return Column(
          children: [
            Text(context.plural("failedToRestoreXImages", errorNum), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
            SmallButton(
              onClick: close,
              child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
          ],
        );
      }
    );

    await deletionRecord.restore(
      onProgress: (double restoreProgress){
        progress.value = restoreProgress;
      },
      onFinish: (int successes, int failures){
        errorNum = failures;
      },
    );

    progress.value = 1;
  }

  Future<void> _delete(BuildContext context, DeletionRecord deletionRecord) async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
          child: DeleteDirectoryProcessor(
            directory: deletionRecord.getAlbumRecycleBinPath().directory,
            safeTimeSecond: 0,
            message: context.tr("deleteMessage"),
            onCancel: (){
              Navigator.of(context).pop();
            },
            onFinish: (){
              Navigator.of(context).pop();
            },
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (BuildContext context, int index){
        final DeletionRecord deletionRecord = records[index];

        String typeStr = "";
        for(final AlbumType type in deletionRecord.deletionAlbumType){
          typeStr += " ${context.tr(albumsInfoMap[type]!.name)}";
        }

        return SmallButton(
          margin: const EdgeInsets.only(bottom: smallPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: bigPadding,
            vertical: smallPadding,
          ),
          width: null,
          height: smallCardMaxHeight,
          colorRole: ColorRoles.background,
          transparent: false,
          onClick: (){
            final AlbumType? type = deletionRecord.suggestedAlbumType;

            if(type != null) Explorer.openDir(deletionRecord.getAlbumRecycleBinPathWith(type).directory);
          },
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: listSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(deletionRecord.deletionTime.toString(), style: TextStyle(fontSize: 32, color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    ),
                    Row(
                      spacing: listSpacing,
                      children: [
                        Text("uid > ${deletionRecord.uid ?? "无"}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        Text("|", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        Text("${context.tr("quantity")} > ${deletionRecord.quantity}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        Text("|", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        Text("${context.tr("type")} > $typeStr", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                      ],
                    ),
                  ],
                ),
              ),

              Tooltip(
                message: context.tr("restore"),
                child: SmallButton(
                  onClick: (){
                    _restore(context, deletionRecord);
                  },
                  child: Image.asset("assets/icon/undelete.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
                ),
              ),
              Tooltip(
                message: context.tr("permanentlyDelete"),
                child: SmallButton(
                  onClick: (){
                    _delete(context, deletionRecord);
                  },
                  child: Image.asset("assets/icon/delete.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}



class DeletionRecord{
  final DateTime deletionTime;
  final Path installPath;
  final String? uid;
  final List<AlbumType> deletionAlbumType;
  final int quantity;

  const DeletionRecord({
    required this.deletionTime,
    required this.installPath,
    required this.uid,
    required this.deletionAlbumType,
    required this.quantity,
  });

  AlbumType? get suggestedAlbumType{
    if(deletionAlbumType.contains(AlbumType.NikkiPhotos_HighQuality)){
      return AlbumType.NikkiPhotos_HighQuality;
    }

    return deletionAlbumType.where((AlbumType type) => type != AlbumType.NikkiPhotos_LowQuality).firstOrNull ?? deletionAlbumType.firstOrNull;
  }

  Path getAlbumGamePathWith(AlbumType albumType){
    String gameRelativePath = albumsInfoMap[albumType]!.locateInGame;
    if(albumsInfoMap[albumType]!.isRequireUid) gameRelativePath = gameRelativePath.replaceAll(r"$uid$", uid!);
    final Path gameAbsolutePath = installPath + gameRelativePath;
    return gameAbsolutePath;
  }

  Path getAlbumRecycleBinPathWith(AlbumType albumType){
    String recycleRelativePath = albumsInfoMap[albumType]!.locateInRecycleBin.replaceAll(r"$msSinceEpoch$", deletionTime.millisecondsSinceEpoch.toString());
    if(albumsInfoMap[albumType]!.isRequireUid) recycleRelativePath = recycleRelativePath.replaceAll(r"$uid$", uid!);
    final Path recycleAbsolutePath = installPath + recycleRelativePath;
    return recycleAbsolutePath;
  }

  Path getAlbumRecycleBinPath(){
    return installPath + Path(locateToRecycleBin) + deletionTime.millisecondsSinceEpoch.toString();
  }

  Future<void> restore({void Function(double progress)? onProgress, void Function(int successes, int failures)? onFinish}) async{
    int total = 0;
    int errorNum = 0;

    for(final AlbumType type in deletionAlbumType){
      final Path gamePath = getAlbumGamePathWith(type);
      final Path binPath = getAlbumRecycleBinPathWith(type);

      late final List<FileSystemEntity> entities;
      try{
        entities = await binPath.directory.list().toList();
      }catch(e){
        continue;
      }

      int current = 0;
      total += entities.length;

      for(final FileSystemEntity entity in entities){
        if(entity is! File) continue;

        final String filename = Path(entity.path).name;

        try{
          await entity.rename((gamePath + filename).path);
        }catch(e){
          errorNum++;
        }

        onProgress?.call((++current / total).clamp(0, 0.9));
      }
    }

    if(errorNum == 0){
      try{
        await delete();
      }catch(e){
        e;
      }
    }

    onFinish?.call(total - errorNum, errorNum);
    onProgress?.call(1);
  }

  Future<void> delete() async{
    await getAlbumRecycleBinPath().directory.delete(recursive: true);
  }
}


class RecycleBinBuilder extends StatefulWidget{
  final Game game;
  final Widget Function(BuildContext context, Path recycleBinPath, List<DeletionRecord> recodes, void Function() refresh) builder;

  const RecycleBinBuilder({
    super.key,
    required this.game,
    required this.builder,
  });

  @override
  State<RecycleBinBuilder> createState() => _RecycleBinBuilderState();
}
class _RecycleBinBuilderState extends State<RecycleBinBuilder>{

  Path getRecycleBinDir(){
    return widget.game.installPath + locateToRecycleBin;
  }

  Future<List<DeletionRecord>> getDeletionRecord() async{
    final List<DeletionRecord> res = <DeletionRecord>[];

    final Path recycleBinDir = getRecycleBinDir();

    if(!await recycleBinDir.directory.exists()) return res;

    ///  \NikkiAlbumsRecycleBin\$msSinceEpoch$\$albumType$\[$uid$]
    ///                          ===========
    await for(final FileSystemEntity entityNamedMsSinceEpoch in recycleBinDir.directory.list()){
      if(entityNamedMsSinceEpoch is! Directory) continue;

      final String name = Path(entityNamedMsSinceEpoch.path).name;
      final int? msSinceEpoch = int.tryParse(name);
      if(msSinceEpoch == null) continue;

      final DateTime deletionTime = DateTime.fromMillisecondsSinceEpoch(msSinceEpoch);
      String? uid;
      final List<AlbumType> deletionAlbumType = <AlbumType>[];
      int quantity = 0;

      ///  \NikkiAlbumsRecycleBin\$msSinceEpoch$\$albumType$\[$uid$]
      ///                                         =========
      await for(final FileSystemEntity entityNamedAlbumType in entityNamedMsSinceEpoch.list()){
        if(entityNamedAlbumType is! Directory) continue;

        final AlbumType? albumType = AlbumType.fromStrictly(Path(entityNamedAlbumType.path).name);

        if(albumType == null) continue;

        deletionAlbumType.add(albumType);

        ///  \NikkiAlbumsRecycleBin\$msSinceEpoch$\$albumType$\[$uid$]
        ///                                                     ====
        if(albumsInfoMap[albumType]!.isRequireUid){
          await for(final FileSystemEntity entityNamedUid in entityNamedAlbumType.list()){
            if(entityNamedUid is! Directory) continue;

            uid = Path(entityNamedUid.path).name;

            quantity = max(quantity, (await entityNamedUid.list().toList()).length);
          }
        }else{
          quantity = max(quantity, (await entityNamedAlbumType.list().toList()).length);
        }
      }

      res.add(DeletionRecord(
        deletionTime: deletionTime,
        installPath: widget.game.installPath,
        uid: uid,
        deletionAlbumType: deletionAlbumType,
        quantity: quantity,
      ));
    }

    return res..sort((a, b) => b.deletionTime.compareTo(a.deletionTime));
  }

  QuietDirectoryWatcher? watcher;

  void refresh(){
    watcher?.cancel();
    watcher = QuietDirectoryWatcher(
      path: getRecycleBinDir(),
      listener: (){
        setState((){});
      }
    );
    setState((){});
  }

  @override
  void initState(){
    super.initState();
    watcher = QuietDirectoryWatcher(
      path: getRecycleBinDir(),
      listener: (){
        setState((){});
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: getDeletionRecord(),
      waitingBuilder: (BuildContext context, Widget indicator){
        return indicator;
      },
      errorBuilder: (BuildContext context){
        return block0;
      },
      builder: (BuildContext context, List<DeletionRecord> records){
        return widget.builder(context, getRecycleBinDir(), records, refresh);
      },
    );
  }

  @override
  void dispose(){
    super.dispose();
    watcher?.cancel();
    watcher = null;
  }
}




class DeleteDirectoryProcessor extends StatefulWidget{
  final Directory directory;
  final int safeTimeSecond;
  final String? message;
  final void Function()? onCancel;
  final void Function()? onFinish;

  const DeleteDirectoryProcessor({
    super.key,
    required this.directory,
    int safeTimeSecond = 0,
    this.message,
    this.onCancel,
    this.onFinish,
  }) : safeTimeSecond = safeTimeSecond >= 0 ? safeTimeSecond : 0;

  @override
  State<DeleteDirectoryProcessor> createState() => _DeleteDirectoryProcessorState();
}
class _DeleteDirectoryProcessorState extends State<DeleteDirectoryProcessor>{
  late final ValueNotifier<int> safeTime;
  late final Timer timer;

  bool isStartDelete = false;
  bool isFinishDelete = false;
  String? errorMessage;

  Future<void> startDelete() async{
    isStartDelete = true;
    setState((){});

    try{
      await widget.directory.delete(recursive: true);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isFinishDelete = true;
      setState((){});
    }
  }

  @override
  void initState(){
    super.initState();
    safeTime = ValueNotifier<int>(widget.safeTimeSecond);
    timer = Timer.periodic(const Duration(seconds: 1), (_){
      safeTime.value = safeTime.value > 0 ? safeTime.value - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(smallPadding),
      constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
      child: Column(
        spacing: listSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message ?? context.tr("delete"), style: TextStyle(fontSize: 18, color: AppTheme.of(context)!.colorScheme.secondary.onColor)),

          block10H,

          if(isStartDelete == false)
            Row(
            spacing: listSpacing,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: safeTime,
                  builder: (BuildContext context, int time, Widget? child){
                    final String text = time == 0 ? context.tr("delete") : "${context.tr("delete")} ($time s)";

                    return SmallButton(
                      usable: time == 0,
                      width: null,
                      colorRole: ColorRoles.background,
                      transparent: false,
                      onClick: (){
                        startDelete();
                      },
                      child: Text(text, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                    );
                  },
                ),
              ),
              Expanded(
                child: SmallButton(
                  width: null,
                  colorRole: ColorRoles.highlight,
                  transparent: false,
                  onClick: widget.onCancel,
                  child: Text(context.tr("cancel"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.highlight.onColor)),
                ),
              ),
            ],
          ),

          if(isStartDelete == true && isFinishDelete == false)
            LinearProgressIndicator(
              value: null,
              backgroundColor: AppTheme.of(context)!.colorScheme.primary.color,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.of(context)!.colorScheme.primary.onColor),
              minHeight: 4,
            ),

          if(isStartDelete == true && isFinishDelete == true && errorMessage == null)
            Text(context.tr("deletionCompleted"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
          if(isStartDelete == true && isFinishDelete == true && errorMessage != null)
            Text(context.tr("deletionFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
          if(errorMessage != null)
            Text(errorMessage.toString(), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
          if(isStartDelete == true && isFinishDelete == true)
            SmallButton(
              width: null,
              colorRole: ColorRoles.background,
              transparent: false,
              onClick: widget.onFinish,
              child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
        ],
      ),
    );
  }

  @override
  void dispose(){
    safeTime.dispose();
    timer.cancel();
    super.dispose();
  }
}











