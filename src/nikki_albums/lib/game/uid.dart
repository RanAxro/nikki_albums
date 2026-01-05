


import "package:nikkialbums/info.dart";
import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/Image.dart";
import "package:nikkialbums/state.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:convert";



class UidNote{
  static Map<String, String?>? toJsonMap(UidNote? uidNote){
    if(uidNote == null) return null;

    return {
      "note": uidNote.note,
      "installPath": uidNote.installPath.path,
      "value": uidNote.value,
    };
  }

  static UidNote? from(dynamic map){
    if(map is String) map = jsonDecode(map);
    if(map is! Map) return null;

    final Path? installPath = Path.from(map["installPath"]);

    if(map["note"] is! String || installPath == null || map["value"] is! String) return null;

    return UidNote(
      note: map["note"],
      installPath: installPath,
      value: map["value"],
    );
  }


  final String note;
  final Path installPath;
  final String value;

  const UidNote({
    required this.note,
    required this.installPath,
    required this.value,
  });

  bool hasSame(Iterable<UidNote> iterable){
    return iterable.any((UidNote test) => installPath == test.installPath && value == test.value);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is UidNote && runtimeType == other.runtimeType &&
    installPath == other.installPath && value == other.value;

  @override
  int get hashCode => Object.hash(installPath, value);

  @override
  String toString() => "$note $value";
}


class Uid{
  static Map<String, String?>? toJsonMap(Uid? uid){
    if(uid == null) return null;

    return {
      "installPath": uid.installPath.path,
      "value": uid.value,
    };
  }

  static Uid? from(dynamic map){
    if(map is String) map = jsonDecode(map);
    if(map is! Map) return null;

    final Path? installPath = Path.from(map["installPath"]);

    if(installPath == null || map["value"] is! String) return null;

    final Uid res = Uid(
      installPath: installPath,
      value: map["value"],
    );
    return res;
  }


  final Path installPath;
  final String value;
  Future<Path?> _avatar = Future.value(null);
  Future<FileImage?> _avatarImage = Future<FileImage?>.value(null);

  Uid({
    required this.installPath,
    required this.value,
  }){
    updateAvatar();
  }


  /// ---------- name ---------- ///

  String? get note{
    for(final UidNote uidNote in AppState.uidNotes.value){
      if(installPath == uidNote.installPath && value == uidNote.value){
        return uidNote.note;
      }
    }
    return null;
  }

  set note(String? note){
    UidNote? oldNote;

    for(final UidNote uidNote in AppState.uidNotes.value){
      if(installPath == uidNote.installPath && value == uidNote.value){
        oldNote = uidNote;
      }
    }

    final UidNote? newNote = note == null ? null : UidNote(note: note, installPath: installPath, value: value);

    AppState.uidNotes.value = {?newNote, ...AppState.uidNotes.value..remove(oldNote)};
  }

  String get name{
    return note ?? value;
  }

  /// ---------- avatar ---------- ///

  Future<Path?> get avatar => _avatar;
  Future<FileImage?> get avatarImage => _avatarImage;

  /// 从"CustomAvatar"找最新的头像图像
  ///
  /// find the latest player avatar from game album "CustomAvatar"
  Future<Path?> _getAvatar() async{
    final Directory avatarDirectory = (installPath + albumsInfoMap[AlbumType.CustomAvatar]!.locateInGame.replaceAll(r"$uid$", value)).directory;

    if(!(await avatarDirectory.exists())) return null;

    final List<FileSystemEntity> entities = await avatarDirectory
      .list(recursive: false)
      .where((entity) => entity is File && isImageExtension(Path(entity.path)))
      .toList();

    if(entities.isEmpty) return null;

    final List<Path> avatarList = entities.map((entity) => Path(entity.path)).toList();

    for(Path item in avatarList){
      await item.statAsync;
    }

    avatarList.sort((a, b) => b.cacheStat.modified.compareTo(a.cacheStat.modified));

    return avatarList.first;
  }

  Future<Path?> updateAvatar(){
    _avatar = _getAvatar();
    _avatarImage = _avatar.then((Path? avatarPath){
      return avatarPath == null ? null : FileImage(avatarPath.file);
    });

    return _avatar;
  }


  /// ---------- class ---------- ///

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Uid && runtimeType == other.runtimeType &&
    installPath == other.installPath && value == other.value;

  @override
  int get hashCode => Object.hash(installPath, value);

  @override
  String toString() => value;
}