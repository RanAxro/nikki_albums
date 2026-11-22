
import "package:nikki_albums/modules/media_library/media_library.dart";

import "package:flutter_hooks/flutter_hooks.dart";


AlbumController<T> useAlbumController<T extends MediaItem>(MediaItemProvider<T> provider){
  final AlbumController<T> controller = useMemoized(
    () => AlbumController<T>(provider: provider),
    <Object?>[provider],
  );

  useEffect(() => controller.dispose, <Object?>[controller]);

  return controller;
}

class AlbumController<T extends MediaItem> extends LibraryController<T> with InitializationMixin<T>, SortAndClassificationMixin<T>, SelectionMixin<T>{
  AlbumController({required super.provider});
}