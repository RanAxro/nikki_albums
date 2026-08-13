enum LauncherChannel{
  unknown("infinity_nikki.launcher_channel.unknown"),
  paper("infinity_nikki.launcher_channel.paper", "assets/logo/paper"),
  paperGlobal("infinity_nikki.launcher_channel.paper_global", "assets/logo/paper"),
  taptap("infinity_nikki.launcher_channel.taptap", "assets/logo/taptap"),
  bilibili("infinity_nikki.launcher_channel.bilibili", "assets/logo/bilibili"),
  steam("infinity_nikki.launcher_channel.steam", "assets/logo/steam");

  final String nameKey;
  final String? logoAssetName;

  const LauncherChannel(this.nameKey, [this.logoAssetName]);

  static LauncherChannel from(dynamic value){
    return LauncherChannel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => LauncherChannel.unknown,
    );
  }

  String to() => name;
}