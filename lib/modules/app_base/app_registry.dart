
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/modules/start/start.dart" as start_page;
import "package:nikki_albums/modules/album/album.dart" as album_page;
import "package:nikki_albums/modules/file_transfer/file_transfer.dart" as file_transfer_page;
import "package:nikki_albums/modules/parameter_manager/parameter_manager.dart" as parameter_manager_page;
import "package:nikki_albums/modules/resource/resource.dart" as resource_page;
import "package:nikki_albums/modules/recycle_bin/recycle_bin.dart" as recycle_bin;


abstract class AppRegistry{
  static const List<String> langFile = [
    "infinity_nikki",
    "infinity_nikki/cloth",
    "infinity_nikki/cloth_outfit",
    "infinity_nikki/other",
  ];


  static final List<ContentItem> homeContent = [
    start_page.item,
    album_page.item,
    file_transfer_page.item,
    // parameter_manager_page.item,
    resource_page.item,
    // creation.item,
    recycle_bin.item,
  ];
}