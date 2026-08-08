
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
    searchLight: false,
    searchFilter: false,
  );

  final String value;
  final bool searchName;
  final bool searchTag;
  final bool searchClothesName;
  final bool searchOutfitName;
  final bool searchClothMajorPropName;
  final bool searchClothTagName;
  final bool searchLight;
  final bool searchFilter;

  const SearchConfig({
    required this.value,
    required this.searchName,
    required this.searchTag,
    required this.searchClothesName,
    required this.searchOutfitName,
    required this.searchClothMajorPropName,
    required this.searchClothTagName,
    required this.searchLight,
    required this.searchFilter,
  });

  SearchConfig copyWith({
    String? value,
    bool? searchName,
    bool? searchTag,
    bool? searchClothesName,
    bool? searchOutfitName,
    bool? searchClothMajorPropName,
    bool? searchClothTagName,
    bool? searchLight,
    bool? searchFilter,
  }){
    return SearchConfig(
      value: value ?? this.value,
      searchName: searchName ?? this.searchName,
      searchTag: searchTag ?? this.searchTag,
      searchClothesName: searchClothesName ?? this.searchClothesName,
      searchOutfitName: searchOutfitName ?? this.searchOutfitName,
      searchClothMajorPropName: searchClothMajorPropName ?? this.searchClothMajorPropName,
      searchClothTagName: searchClothTagName ?? this.searchClothTagName,
      searchLight: searchLight ?? this.searchLight,
      searchFilter: searchFilter ?? this.searchFilter,
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
    other.searchLight == searchLight &&
    other.searchFilter == searchFilter;

  @override
  int get hashCode => Object.hash(
    value,
    searchName,
    searchTag,
    searchClothesName,
    searchOutfitName,
    searchClothMajorPropName,
    searchClothTagName,
    searchLight,
    searchFilter,
  );
}