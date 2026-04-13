part of "../../lib/uid.dart";

bool isUidType(String source){
  return RegExp(r"^\d{9}$").hasMatch(source);
}

extension on Uid{
  Future<String?> getAvatar() => AvatarProvider.byUid(this);
}