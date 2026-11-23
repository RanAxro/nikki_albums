
import "item.dart";
import "item_provider.dart";
import "../model/sorting_method.dart";
import "../model/classification_standard.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "package:flutter/widgets.dart";
import "dart:collection";
import "dart:async";

part "library_controller_mixin/initialization_mixin.dart";
part "library_controller_mixin/sort_and_classification_mixin.dart";
part "library_controller_mixin/selection_mixin.dart";
part "library_controller_mixin/tag_mixin.dart";
part "library_controller_mixin/extra_mixin.dart";


class LibraryController<T extends MediaItem> extends ChangeNotifier{
  final MediaItemProvider<T> provider;

  LibraryController({required this.provider}){
    provider.addListener(_onItemChange);
  }

  void _onItemChange(){
    onItemChanged(provider.items.toSet());
  }

  List<T> get items{
    return List<T>.from(getItems(provider.items));
  }

  void refresh(){
    notify();
  }

  @protected
  @visibleForTesting
  @mustCallSuper
  Iterable<T> getItems(Iterable<T> rawItems){
    return rawItems;
  }

  @protected
  @visibleForTesting
  @mustCallSuper
  Future<void> onItemChanged(Set<T> newItems) async{

  }

  @protected
  @visibleForTesting
  void notify(){
    notifyListeners();
  }

  @override
  void dispose(){
    provider.removeListener(_onItemChange);
    super.dispose();
  }
}