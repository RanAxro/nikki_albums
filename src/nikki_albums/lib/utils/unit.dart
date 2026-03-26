String formatBytes(int bytes, {int decimals = 2}){
  if(bytes <= 0) return "0 B";

  const List<String> suffixes = ["B", "KB", "MB", "GB", "TB", "PB"];
  final i = (bytes.bitLength ~/ 10).clamp(0, suffixes.length - 1);
  final size = bytes / (1 << (i * 10));

  return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
}