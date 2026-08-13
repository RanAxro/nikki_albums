
dynamic deepStringifyKeys(dynamic value){
  if(value is Map){
    return value.map((k, v) => MapEntry(
      k.toString(),
      deepStringifyKeys(v),  // 递归处理 value，确保子 Map 也被清洗
    ));
  }
  if(value is List){
    return value.map(deepStringifyKeys).toList();
  }
  // 基础类型直接返回
  return value;
}


/// 在原 Map 上深层合并另一个 Map
/// base 会被直接修改，overlay 的键递归合并进 base
void deepMergeMapsInPlace(
  Map<String, dynamic> base,
  Map<String, dynamic> overlay,
){
  overlay.forEach((String key, dynamic value){
    if(value is Map && base[key] is Map<String, dynamic>){
      // 两边都是 Map，递归进子节点继续合并
      deepMergeMapsInPlace(
        base[key] as Map<String, dynamic>,
        value.map((k, v) => MapEntry(
          k.toString(),
          v,  // 无需deepStringifyKeys，由deepMergeMapsInPlace递归处理
        )),
      );
    }else{
      // 直接覆盖（包括 List、基本类型、null 等）
      base[key] = deepStringifyKeys(value);
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


// 打印所有非基础类型的值
void debugInspectTypes(dynamic value, [String path = '']){
  if(value is Map){
    value.forEach((k, v){
      debugInspectTypes(k, '$path._$k');
      debugInspectTypes(v, '$path.$k');
    });
  }else if (value is List){
    for(var i = 0; i < value.length; i++){
      debugInspectTypes(value[i], '$path[$i]');
    }
  }else if(value != null && value is! String && value is! num && value is! bool){
    print('🔍 非基础类型 @ $path: ${value.runtimeType} = $value');
  }
}
void debugInspectKeys(dynamic value, [String path = '']){
  if(value is Map){
    value.forEach((k, v){
      final keyPath = '$path[$k]';
      if(k is! String){
        print('🔴 非 String key @ $path: ${k.runtimeType} key = $k');
      }
      debugInspectKeys(v, keyPath);
    });
  }else if(value is List){
    for(var i = 0; i < value.length; i++){
      debugInspectKeys(value[i], '$path[$i]');
    }
  }
}