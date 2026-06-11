
import "../model/hot_update_info.dart";
import "get_hot_update_info.dart";
import "hot_update_service.dart";


Future<bool> checkAppHotUpdates() async{
  final List<HotUpdateInfo> infos = await getUpdateInfo();

  final HotUpdater updater = HotUpdater();
  return updater.update(infos);
}