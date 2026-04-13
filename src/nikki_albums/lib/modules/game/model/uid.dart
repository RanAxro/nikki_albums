part of "../lib/uid.dart";


class Uid{
  final String installPath;
  final String value;

  const Uid._({
    required this.installPath,
    required this.value,
  });

  factory Uid._new({
    required String installPath,
    required String value,
  }){
    if(!isUidType(value)){
      throw IncorrectUidFormatException(value);
    }

    return Uid._(installPath: installPath, value: value);
  }

  factory Uid.ofGame(Game game, String uid){
    return Uid._new(installPath: game.installPath, value: uid);
  }

  factory Uid.ofUidNote(UidNote uidNote){
    return Uid._new(installPath: uidNote.installPath, value: uidNote.value);
  }

  String? get note{

  }

  set note(String? arg){

  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Uid && runtimeType == other.runtimeType &&
      installPath == other.installPath &&
      value == other.value;

  @override
  int get hashCode => Object.hash(installPath, value);

  @override
  String toString() => "Uid -> $value";
}
