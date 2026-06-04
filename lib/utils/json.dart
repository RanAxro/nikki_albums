/// 在原 Map 上深层合并另一个 Map
/// base 会被直接修改，overlay 的键递归合并进 base
void deepMergeMapsInPlace(
  Map<String, dynamic> base,
  Map<String, dynamic> overlay,
){
  overlay.forEach((key, value){
    if(value is Map<String, dynamic> && base[key] is Map<String, dynamic>){
      // 两边都是 Map，递归进子节点继续合并
      deepMergeMapsInPlace(
        base[key] as Map<String, dynamic>,
        value,
      );
    }else{
      // 直接覆盖（包括 List、基本类型、null 等）
      base[key] = value;
    }
  });
}

/// 把多个 Map 依次合并到第一个 Map 上
/// 第一个 Map 会被直接修改，后面的作为增量
void mergeMultipleMapsInPlace(
  Map<String, dynamic> base,
  List<Map<String, dynamic>> overlays,
){
  for(final overlay in overlays){
    deepMergeMapsInPlace(base, overlay);
  }
}