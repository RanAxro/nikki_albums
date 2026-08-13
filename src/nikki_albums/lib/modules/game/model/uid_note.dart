part of "../lib/uid_note.dart";


class UidNote{
  final String installPath;
  final String value;
  final String note;

  const UidNote._({
    required this.installPath,
    required this.value,
    required this.note,
  });

  factory UidNote.ofUid(Uid uid, String note){
    return UidNote._(installPath: uid.installPath, value: uid.value, note: note);
  }

  factory UidNote.withNote(UidNote uidNote, String note){
    return UidNote._(installPath: uidNote.installPath, value: uidNote.value, note: note);
  }

  bool isSameUid(UidNote other){
    return p.equals(other.installPath, installPath) && other.value == value;
  }

  bool hasSameUid(Iterable<UidNote> others){
    return others.any(isSameUid);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is UidNote && runtimeType == other.runtimeType &&
      installPath == other.installPath &&
      value == other.value &&
      note == other.note;

  @override
  int get hashCode => Object.hash(installPath, value, note);

  @override
  String toString() => "UidNote -> note: $note, value: $value";
}