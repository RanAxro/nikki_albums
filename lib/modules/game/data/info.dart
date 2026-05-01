enum LauncherChannel {
  unknown,
  paper,
  taptap,
  bilibili,
  steam;

  static LauncherChannel from(dynamic value) {
    return LauncherChannel.values.firstWhere(
      (LauncherChannel e) => e.name == value || e == value,
      orElse: () => LauncherChannel.unknown,
    );
  }
}
