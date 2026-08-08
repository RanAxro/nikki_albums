
enum SearchOption{
  name,
  tag,
  clothesName,
  outfitName,
  clothPropName,
  clothTagName,
  light,
  filter,
}

class SearchConfig{
  static const SearchConfig defaultConfig = SearchConfig(
    value: "",
    searchName: true,
    searchTag: true,
    searchClothesName: false,
    searchOutfitName: false,
    searchClothMajorPropName: false,
    searchClothTagName: false,
    searchLightOrFilter: false,
  );

  final String value;
  final bool searchName;
  final bool searchTag;
  final bool searchClothesName;
  final bool searchOutfitName;
  final bool searchClothMajorPropName;
  final bool searchClothTagName;
  final bool searchLightOrFilter;

  const SearchConfig({
    required this.value,
    required this.searchName,
    required this.searchTag,
    required this.searchClothesName,
    required this.searchOutfitName,
    required this.searchClothMajorPropName,
    required this.searchClothTagName,
    required this.searchLightOrFilter,
  });

  SearchConfig copyWith({
    String? value,
    bool? searchName,
    bool? searchTag,
    bool? searchClothesName,
    bool? searchOutfitName,
    bool? searchClothMajorPropName,
    bool? searchClothTagName,
    bool? searchLightOrFilter,
  }){
    return SearchConfig(
      value: value ?? this.value,
      searchName: searchName ?? this.searchName,
      searchTag: searchTag ?? this.searchTag,
      searchClothesName: searchClothesName ?? this.searchClothesName,
      searchOutfitName: searchOutfitName ?? this.searchOutfitName,
      searchClothMajorPropName: searchClothMajorPropName ?? this.searchClothMajorPropName,
      searchClothTagName: searchClothTagName ?? this.searchClothTagName,
      searchLightOrFilter: searchLightOrFilter ?? this.searchLightOrFilter,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is SearchConfig &&
    other.runtimeType == runtimeType &&
    other.value == value &&
    other.searchName == searchName &&
    other.searchTag == searchTag &&
    other.searchClothesName == searchClothesName &&
    other.searchOutfitName == searchOutfitName &&
    other.searchClothMajorPropName == searchClothMajorPropName &&
    other.searchClothTagName == searchClothTagName &&
    other.searchLightOrFilter == searchLightOrFilter;

  @override
  int get hashCode => Object.hash(
    value,
    searchName,
    searchTag,
    searchClothesName,
    searchOutfitName,
    searchClothMajorPropName,
    searchClothTagName,
    searchLightOrFilter,
  );
}