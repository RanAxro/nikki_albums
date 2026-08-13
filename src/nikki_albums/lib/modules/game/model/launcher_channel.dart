enum LauncherChannel{
  unknown,
  paper,
  paperGlobal,
  taptap,
  bilibili,
  steam;

  static LauncherChannel from(dynamic value){
    return LauncherChannel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => LauncherChannel.unknown,
    );
  }

  String to() => name;
}