
import "../model/hot_update_info.dart";
import "get_hot_update_info.dart";
import "hot_update_service.dart";


Future<void> checkAppHotUpdates() async{
  final List<HotUpdateInfo> infos = await getUpdateInfo();

  final HotUpdater updater = HotUpdater();
  await updater.update(infos);
}