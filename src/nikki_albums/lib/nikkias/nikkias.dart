
export "nikkias_manifest.dart";
export "nikkias_action.dart";

import "nikkias_manifest.dart";
import "nikkias_action.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/ipc.dart";
import "package:nikkialbums/game/uid.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/utils/archive.dart";
import "package:nikkialbums/utils/path.dart";

import "package:flutter/material.dart";
import "dart:convert";
import "dart:io";
import "dart:ffi";

import "package:archive/archive.dart";
import "package:win32_registry/win32_registry.dart";



const String nikkiasExtension = "nikkias";
const String nikkiasManifestFileName = "manifest";
const String nikkiasContentDirName = "content";

const String nikkiasWholeExtension = ".nikkias";
const String nikkiasFileProgId = "NikkiAlbums.Archive.1";
const String nikkiasFileFriendlyName = "Nikki Albums Images Archive";


//  f1/
//  f1/img1.jpeg
//  manifest
//  testcomp.zip
//  null
NikkiasManifest? getNikkiasManifest(File file){
  try{
    if(!file.existsSync()) return null;

    final InputFileStream inputStream = InputFileStream(file.path);
    final Archive archive = ZipDecoder().decodeStream(inputStream);

    for(final ArchiveFile archiveFile in archive){
      if(!archiveFile.isFile) continue;

      if(archiveFile.name.toLowerCase() != nikkiasManifestFileName) continue;

      final String jsonStr = utf8.decode(archiveFile.content);

      final NikkiasManifest? manifest = NikkiasManifest.decode(jsonStr);

      if(manifest == null) continue;

      inputStream.close();
      return manifest;
    }

    inputStream.close();
    return null;
  }catch(e){
    return null;
  }
}




abstract class NikkiasCodec{
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const NikkiasCodec(this.manifest, this.nikkiasFile);

  Future<void> decode(void Function(double)? onProgress);

  Future<bool> _prepareDecode() async{
    if(!nikkiasFile.existsSync()) return false;

    final InputFileStream inputStream = InputFileStream(nikkiasFile.path);
    final Archive archive = ZipDecoder().decodeStream(inputStream);

    /// verify
    for(final ArchiveFile archiveFile in archive){
      if(!archiveFile.isFile) continue;

      if(archiveFile.name.toLowerCase() != nikkiasManifestFileName) continue;

      final String jsonStr = utf8.decode(archiveFile.content);

      final NikkiasManifest? manifest = NikkiasManifest.decode(jsonStr);

      if(manifest == null) continue;

      if(manifest == this.manifest){
        await inputStream.close();
        return true;
      }else{
        await inputStream.close();
        return false;
      }
    }
    await inputStream.close();
    return false;
  }

  Future<void> encode(void Function(double)? onProgress);

  Future<File> _prepareEncode() async{
    if(await nikkiasFile.exists()) await nikkiasFile.delete();
    await nikkiasFile.create(recursive: true);

    final File manifestFile = (Path(nikkiasFile.path).cut(1) + ("${Path(nikkiasFile.path).name}.manifest")).file;
    if(await manifestFile.exists()) await manifestFile.delete();
    await manifestFile.create();
    manifestFile.writeAsString(NikkiasManifest.encode(manifest));

    return manifestFile;
  }

  static Future<void> decompress(File nikkiasFile, Directory to, [void Function(double)? onProgress]) async{
    final Path savePath = Path(to.path) + Path(nikkiasFile.path).subName;
    try{
      if(await savePath.directory.exists()) await savePath.directory.delete(recursive: true);

      await decompressZipIo(nikkiasFile, savePath.directory, (double decompressProgress){
        onProgress?.call(decompressProgress * 0.9);
      });

      final Path manifestPath = savePath + "manifest";
      if(await manifestPath.file.exists()) await manifestPath.file.delete();
    }finally{
      onProgress?.call(1);
    }
  }
}


class AlbumBackupNikkiasCodec extends NikkiasCodec{
  final Path installPath;
  List<String>? uidWhitelist;
  List<AlbumType>? albumWhitelist;

  AlbumBackupNikkiasCodec(AlbumBackupNikkiasManifest super.manifest, super.nikkiasFile, this.installPath);

  @override
  Future<void> decode(void Function(double)? onProgress) async{
    final bool verify = await _prepareDecode();
    if(!verify){
      return onProgress?.call(1);
    }

    // /// verify
    // for(final ArchiveFile archiveFile in archive){
    //   if(!archiveFile.isFile) continue;
    //
    //   if(archiveFile.name.toLowerCase() != nikkiasManifestFileName) continue;
    //
    //   final String jsonStr = utf8.decode(archiveFile.content);
    //
    //   final NikkiasManifest? manifest = NikkiasManifest.decode(jsonStr);
    //
    //   if(manifest == null) continue;
    //
    //   if(manifest == this.manifest){
    //     break;
    //   }else{
    //     await inputStream.close();
    //     return onProgress?.call(1);
    //   }
    // }


    /// decode
    await decompressZipIo(nikkiasFile, installPath.directory, (double decompressProgress){
      onProgress?.call(decompressProgress * 0.99);
    });

    await (installPath + nikkiasManifestFileName).file.delete();
    onProgress?.call(1);
  }

  @override
  Future<void> encode(void Function(double)? onProgress) async{
    final File manifestFile = await _prepareEncode();

    final List<Uid> uidList = List.from(await FindUid.find(installPath));
    if(uidWhitelist != null){
      uidList.removeWhere((Uid uid) => !uidWhitelist!.contains(uid.value));
    }

    List<File> files = [manifestFile];
    List<Path> archiveFilePaths = [Path(nikkiasManifestFileName)];

    for(final MapEntry<AlbumType, AlbumsInfoItem> info in albumsInfoMap.entries){
      if(albumWhitelist != null && !albumWhitelist!.contains(info.key)) continue;

      if(info.value.isRequireUid){
        for(final Uid uid in uidList){
          final List<File> imageFiles = await listDirFile((installPath + info.value.locateInGame.replaceAll(r"$uid$", uid.value)).directory);
          final List<Path> imageArchiveFilePaths = imageFiles.map((File file) => Path(file.path.substring(installPath.path.length + 1))).toList();

          files.addAll(imageFiles);
          archiveFilePaths.addAll(imageArchiveFilePaths);

          if(info.value.locateInBackup != null){
            final List<File> backupImageFiles = await listDirFile((installPath + info.value.locateInBackup!.replaceAll(r"$uid$", uid.value)).directory);
            final List<Path> backupImageArchiveFilePaths = backupImageFiles.map((File file) => Path(file.path.substring(installPath.path.length + 1))).toList();

            files.addAll(backupImageFiles);
            archiveFilePaths.addAll(backupImageArchiveFilePaths);
          }
        }
      }else{
        final List<File> imageFiles = await listDirFile((installPath + info.value.locateInGame).directory);
        final List<Path> imageArchiveFilePaths = imageFiles.map((File file) => Path(file.path.substring(installPath.path.length + 1))).toList();

        files.addAll(imageFiles);
        archiveFilePaths.addAll(imageArchiveFilePaths);

        if(info.value.locateInBackup != null){
          final List<File> backupImageFiles = await listDirFile((installPath + info.value.locateInBackup!).directory);
          final List<Path> backupImageArchiveFilePaths = backupImageFiles.map((File file) => Path(file.path.substring(installPath.path.length + 1))).toList();

          files.addAll(backupImageFiles);
          archiveFilePaths.addAll(backupImageArchiveFilePaths);
        }
      }
    }

    await compressZipIoX(files, archiveFilePaths, nikkiasFile, onProcess: (double decompressProgress){
      onProgress?.call(decompressProgress * 0.99);
    });

    await manifestFile.delete();

    onProgress?.call(1);
  }
}

class ImageTransferNikkiasCodec extends NikkiasCodec{
  final Path installPath;
  List<String>? filenameWhitelist;

  ImageTransferNikkiasCodec(ImageTransferNikkiasManifest super.manifest, super.nikkiasFile, this.installPath);

  @override
  Future<void> decode(void Function(double)? onProgress) async{
    final bool verify = await _prepareDecode();
    if(!verify){
      return onProgress?.call(1);
    }

    final AlbumsInfoItem albumInfo = albumsInfoMap[(manifest as ImageTransferNikkiasManifest).albumType]!;
    final Path albumPath = installPath + (albumInfo.isRequireUid ? albumInfo.locateInGame.replaceAll(r"$uid$", (manifest as ImageTransferNikkiasManifest).uid) : albumInfo.locateInGame);

    /// decode
    await decompressZipIo(nikkiasFile, albumPath.directory, (double decompressProgress){
      onProgress?.call(decompressProgress * 0.99);
    });

    await (albumPath + nikkiasManifestFileName).file.delete();
    onProgress?.call(1);
  }

  @override
  Future<void> encode(void Function(double)? onProgress) async{
    final File manifestFile = await _prepareEncode();

    List<File> files = [manifestFile];
    List<Path> archiveFilePaths = [Path(nikkiasManifestFileName)];

    final AlbumsInfoItem albumInfo = albumsInfoMap[(manifest as ImageTransferNikkiasManifest).albumType]!;
    final Path albumPath = installPath + (albumInfo.isRequireUid ? albumInfo.locateInGame.replaceAll(r"$uid$", (manifest as ImageTransferNikkiasManifest).uid) : albumInfo.locateInGame);

    final List<File> imageFiles = await listDirFile(albumPath.directory);
    if(filenameWhitelist != null){
      imageFiles.removeWhere((File file) => !filenameWhitelist!.contains(Path(file.path).name));
    }
    final List<Path> imageArchiveFilePaths = imageFiles.map((File file) => Path(Path(file.path).name)).toList();
    files.addAll(imageFiles);
    archiveFilePaths.addAll(imageArchiveFilePaths);

    await compressZipIoX(files, archiveFilePaths, nikkiasFile, onProcess: (double decompressProgress){
      onProgress?.call(decompressProgress * 0.99);
    });

    await manifestFile.delete();

    onProgress?.call(1);
  }
}

class OtherNikkiasCodec extends NikkiasCodec{
  final Path saveDir;

  OtherNikkiasCodec(OtherNikkiasManifest super.manifest, super.nikkiasFile, this.saveDir);

  @override
  Future<void> decode(void Function(double)? onProgress) async{
    final Path savePath = saveDir + Path(nikkiasFile.path).subName;

    if(await savePath.directory.exists()) await savePath.directory.delete(recursive: true);

    await decompressZipIo(nikkiasFile, savePath.directory, (double decompressProgress){
      onProgress?.call(decompressProgress * 0.99);
    });

    final Path manifestPath = savePath + "manifest";
    if(await manifestPath.file.exists()) await manifestPath.file.delete();

    onProgress?.call(1);
  }

  @override
  Future<void> encode(void Function(double)? onProgress) async{

  }
}



Future<List<File>> listDirFile(Directory dir) async{
  final List<File> files = [];

  await for(final entity in dir.list(recursive: true, followLinks: false)){
    if(entity is File){
      files.add(entity);
    }
  }

  return files;
}




abstract class Nikkias{
  static Future<void> init() async{
    // IPC.listen(_ipcHandle);

    Future.delayed(const Duration(seconds: 1)).then((_){
      WidgetsBinding.instance.addPostFrameCallback((_){
        _appStateProcessor();
      });
    });
    AppState.nikkiasToBeParsed.addListener(_appStateProcessor);

    if(Platform.isWindows && AppState.needFileAssociationHelper.value){
      await registerFileAssociation();
      AppState.needFileAssociationHelper.value = false;
    }
  }

  static void _ipcHandle(String str){
    AppState.nikkiasToBeParsed.value = str;
  }

  static void _appStateProcessor(){
    if(AppState.nikkiasToBeParsed.value == null) return;

    final BuildContext? context = frameKey.currentContext;

    if(context != null){
      parseNikkiasFile(context, File(AppState.nikkiasToBeParsed.value!));
    }

    AppState.nikkiasToBeParsed.value = null;
  }

  static Future<void> registerFileAssociation() async{
    final exePath = Platform.resolvedExecutable;

    // 打开 HKCU\Software\Classes
    final hkcu = Registry.openPath(RegistryHive.currentUser);

    try{
      // 注册扩展名: .nikkias -> NikkiasApp.File
      final RegistryKey extKey = hkcu.createKey("Software\\Classes\\$nikkiasWholeExtension");
      extKey.createValue(RegistryValue.string("", nikkiasFileProgId));
      extKey.close();

      // 创建 ProgID 主键
      final RegistryKey progKey = hkcu.createKey("Software\\Classes\\$nikkiasFileProgId");
      progKey.createValue(RegistryValue.string("", nikkiasFileFriendlyName));

      // 设置默认图标（使用程序自身的图标，索引0）
      final RegistryKey iconKey = progKey.createKey("DefaultIcon");
      iconKey.createValue(RegistryValue.string("", "$exePath,0"));
      iconKey.close();

      // 设置打开命令
      final RegistryKey cmdKey = progKey.createKey(r"shell\open\command");
      cmdKey.createValue(RegistryValue.string("", '"$exePath" "%1"'));
      cmdKey.close();

      progKey.close();
    }finally{
      hkcu.close();
    }

    _notifySettingsChange();
  }

  static Future<void> unRegisterFileAssociation() async{
    final hkcu = Registry.openPath(RegistryHive.currentUser);

    try{
      // 删除扩展名
      hkcu.deleteKey("Software\\Classes\\$nikkiasWholeExtension", recursive: true);
      // 删除 ProgID
      hkcu.deleteKey("Software\\Classes\\$nikkiasFileProgId", recursive: true);
    }catch(e){
      AppState.writeError("Nikkias.unRegisterFileAssociation", e.toString());
    }finally{
      hkcu.close();
    }

    _notifySettingsChange();
  }

  static void _notifySettingsChange(){
    final shell32 = DynamicLibrary.open("shell32.dll");
    final shChangeNotify = shell32.lookupFunction<
      Void Function(Uint32 eventId, Uint32 flags, Pointer pidl1, Pointer pidl2),
      void Function(int eventId, int flags, Pointer pidl1, Pointer pidl2)
    >("SHChangeNotify");

    const SHCNE_ASSOCCHANGED = 0x08000000;
    const SHCNF_IDLIST = 0x0000;

    shChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nullptr, nullptr);
  }
}





