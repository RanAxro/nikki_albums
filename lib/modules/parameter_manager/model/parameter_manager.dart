
class SearchConfig{
  static const SearchConfig defaultConfig = SearchConfig(
    value: "",
    searchName: true,
    searchTag: true,
    searchClothesName: false,
    searchOutfitName: false,
  );

  final String value;
  final bool searchName;
  final bool searchTag;
  final bool searchClothesName;
  final bool searchOutfitName;

  const SearchConfig({
    required this.value,
    required this.searchName,
    required this.searchTag,
    required this.searchClothesName,
    required this.searchOutfitName,
  });

  SearchConfig copyWith({
    String? value,
    bool? searchName,
    bool? searchTag,
    bool? searchClothesName,
    bool? searchOutfitName,
  }){
    return SearchConfig(
      value: value ?? this.value,
      searchName: searchName ?? this.searchName,
      searchTag: searchTag ?? this.searchTag,
      searchClothesName: searchClothesName ?? this.searchClothesName,
      searchOutfitName: searchOutfitName ?? this.searchOutfitName,
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
    other.searchOutfitName == searchOutfitName;

  @override
  int get hashCode => Object.hash(value, searchName, searchTag, searchClothesName, searchOutfitName);
}