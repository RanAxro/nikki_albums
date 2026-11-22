
import "../domain/item.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "sorting_method.freezed.dart";


@freezed
sealed class SortingMethod<T extends MediaItem> with _$SortingMethod<T>{
  const factory SortingMethod.random() = SortingMethod_Random<T>;
  const factory SortingMethod.none() = SortingMethod_None<T>;
  const factory SortingMethod.cTime() = SortingMethod_CTime<T>;
  const factory SortingMethod.mTime() = SortingMethod_MTime<T>;
  const factory SortingMethod.size() = SortingMethod_Size<T>;
  const factory SortingMethod.custom(int Function(T a, T b) compare) = SortingMethod_Custom<T>;
}