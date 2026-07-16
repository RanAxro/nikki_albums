
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";

import "package:collection/collection.dart";


const DeepCollectionEquality _unorderedEquality = DeepCollectionEquality.unordered();

extension ClothDiyParamsEquals on ClothDiyParams{
  static final DeepCollectionEquality equality = DeepCollectionEquality.unordered(ClothDiyParamsEquality());

  bool equals(Object other) =>
    identical(this, other) ||
    other is ClothDiyParams &&
      runtimeType == other.runtimeType &&
      equality.equals(this, other);
}

class ClothDiyParamsEquality implements Equality<ClothDiyParams>{
  static final DeepCollectionEquality clothParamsEquality = DeepCollectionEquality.unordered(ClothParamsEquality());

  @override
  bool equals(ClothDiyParams e1, ClothDiyParams e2){
    return e1.poseId == e2.poseId &&
      _unorderedEquality.equals(e1.patternData, e2.patternData) &&
      clothParamsEquality.equals(e1.clothes, e2.clothes);
  }

  @override
  int hash(ClothDiyParams e) => e.poseId.hashCode ^
    _unorderedEquality.hash(e.patternData) ^
    clothParamsEquality.hash(e.clothes);

  @override
  bool isValidKey(Object? o) => o is ClothDiyParams;
}

class ClothParamsEquality implements Equality<ClothParams>{
  static final DeepCollectionEquality diyDataEquality = DeepCollectionEquality.unordered(DiyDataOrEquality());

  @override
  bool equals(ClothParams e1, ClothParams e2){
    return e1.cloth == e2.cloth &&
      diyDataEquality.equals(e1.diy, e2.diy);
  }

  @override
  int hash(ClothParams e) => e.cloth.hashCode ^ diyDataEquality.hash(e.diy);

  @override
  bool isValidKey(Object? o) => o is ClothParams;
}

class DiyDataOrEquality implements Equality<DiyData?>{
  @override
  bool equals(DiyData? e1, DiyData? e2){
    return _unorderedEquality.equals(e1?.outfitDye, e2?.outfitDye) &&
      _unorderedEquality.equals(e1?.specialEffect, e2?.specialEffect) &&
      _unorderedEquality.equals(e1?.patternCreation, e2?.patternCreation);
  }

  @override
  int hash(DiyData? e) => _unorderedEquality.hash(e?.outfitDye) ^
    _unorderedEquality.hash(e?.specialEffect) ^
    _unorderedEquality.hash(e?.patternCreation);

  @override
  bool isValidKey(Object? o) => o is DiyData?;
}