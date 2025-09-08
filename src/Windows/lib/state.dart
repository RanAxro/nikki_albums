import "package:nikki_albums/main.dart";
import "package:nikki_albums/ui/frame.dart";
import "package:nikki_albums/pages/album.dart";

import "package:nikki_albums/api.dart" as api;

import "package:flutter/material.dart";

// ------ global ------

//根 WindowBorder
final GlobalKey ancestor = GlobalKey();

//窗口是否置顶
final ValueNotifier<bool> isTopWindow = ValueNotifier<bool>(false);
//是否正在选择游戏账号
final ValueNotifier<bool> isSelectAccount = ValueNotifier<bool>(false);
//目前所选择的游戏账号
final ValueNotifier<String?> currentAccount = ValueNotifier<String?>(null);
//content页面
final ValueNotifier<int> contentPage = ValueNotifier<int>(1);
//content页面PageView Controller
PageController contentController = PageController(initialPage: 1);

//当前是否在webview
final ValueNotifier<bool> isWebview = ValueNotifier<bool>(false);

// ------ album ------

// final GlobalKey gameImageZone = GlobalKey();
// final GlobalKey backupImageZone = GlobalKey();
//刷新相册
final ValueNotifier<int> refreshAlbum = ValueNotifier<int>(0);
//当前游戏区照片显示列数
final ValueNotifier<int> gameImageColumns = ValueNotifier<int>(2);
//当前备份区照片显示列数
final ValueNotifier<int> backupImageColumns = ValueNotifier<int>(2);
//是否正在选择相册类型
final ValueNotifier<bool> isSelectAlbum = ValueNotifier<bool>(false);
//当前相册类型
final ValueNotifier<String?> currentAlbum = ValueNotifier<String?>(null);
//更新currentAlbum
void updateCurrentAlbum(){
  currentAlbum.value = currentAccount.value == null ?
  null : currentAccount.value!.split(" > ")[1] == "" ?
  "ScreenShot" : "NikkiPhotos";
}
//游戏区照片排序方式, 默认为时间排序倒序
final ValueNotifier<bool> isGamePartForward = ValueNotifier<bool>(false);
//备份区照片排序方式, 默认为时间排序倒序
final ValueNotifier<bool> isBackupPartForward = ValueNotifier<bool>(false);
//备份目录路径
final ValueNotifier<String?> backupFolderPath = ValueNotifier<String?>(null);
//是否显示group列表
final ValueNotifier<bool> isShowGroupList = ValueNotifier<bool>(true);
//当前备份相册的group
final ValueNotifier<String?> currentBackupGroup = ValueNotifier<String?>(null);
//是否正在浏览已位于中转站的图片
final ValueNotifier<bool> isViewSmallImage = ValueNotifier<bool>(false);
//游戏区图片中转站
final ValueNotifier<Map<String, bool>> gameStationImage = ValueNotifier<Map<String, bool>>({});
//备份区图片中转站
final ValueNotifier<Map<String, bool>> backupStationImage = ValueNotifier<Map<String, bool>>({});



void initState(){

  imageCache.maximumSize = 0;
  imageCache.maximumSizeBytes = 0;

// ------ global ------

  //监听窗口是否置顶
  isTopWindow.addListener((){
    api.doTopWindow(isTopWindow.value);
  });

  //监听content页码变换并跳转
  contentPage.addListener((){
    contentController.animateToPage(contentPage.value, duration: Duration(milliseconds: 300), curve: Curves.ease);
  });

  //获取最后一次选择的account
  currentAccount.value = config["selectedAccount"];
  currentAccount.addListener((){
    //保存最后一次选择的account
    save((){config["selectedAccount"] = currentAccount.value;});
    //更新album
    updateCurrentAlbum();
  });

  isSelectAccount.addListener(() async{
    if(isSelectAccount.value){
      accountSelector.build();
    }else{
      accountSelector.close();
    }
  });


// ------ album ------

  //初始化currentAlbum
  updateCurrentAlbum();

  //是否正在选择相册
  isSelectAlbum.addListener((){
    if(isSelectAlbum.value){
      albumSelector.build();
    }else{
      albumSelector.close();
    }
  });

  //当其游戏相册被选中时, 关闭中转站
  currentAlbum.addListener((){
    gameStationImage.value = {};
    backupStationImage.value = {};
  });


  //获取备份文件夹路径
  backupFolderPath.value = config["backupFolderPath"];
  backupFolderPath.addListener((){
    //更新备份文件夹
    save((){config["backupFolderPath"] = backupFolderPath.value;});
  });

  //监听到有图片放入游戏区中转站时打开中转站, 否者关闭
  gameStationImage.addListener((){
    if(gameStationImage.value.isEmpty){
      gameStation.close();
    }else{
      //若备份区中转站未关闭, 则手动关闭
      if(backupStationImage.value.isNotEmpty){
        backupStationImage.value = {};
      }
      //当中转站首次打开时才创建
      if(gameStation.selector == null){
        gameStation.build();
      }
    }
  });
  //监听到有图片放入备份区中转站时打开中转站, 否者关闭
  backupStationImage.addListener((){
    if(backupStationImage.value.isEmpty){
      backupStation.close();
    }else{
      //若备份区中转站未关闭, 则手动关闭
      if(gameStationImage.value.isNotEmpty){
        gameStationImage.value = {};
      }
      //当中转站首次打开时才创建
      if(backupStation.selector == null){
        backupStation.build();
      }
    }
  });

}