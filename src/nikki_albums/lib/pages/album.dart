import "dart:math";
import "dart:ui";

import "package:file_picker/file_picker.dart";
import "package:nikki_albums/main.dart";
import "package:nikki_albums/state.dart";
import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;
import "package:nikki_albums/api.dart" as api;

// import "dart:async";
import "dart:io";

import "package:flutter/material.dart";

//支持的照片类型
const _imageType = ["png", "jpeg", "jpg", "webp", "gif", "bmp", "wbmp", "ico"];

//照片显示列数
const _minColumn = 1;
const _maxColumn = 6;


//game相册名
const albumName = {
  "NikkiPhotos": "大喵相册",
  "MagazinePhotos": "旅行手账",
  "ClockInPhoto":	"世界巡游",
  "DIY": "星绘图册",
  "CustomAvatar": "历史头像",
  "CustomCard":	"历史名片",
  "CloudPhotos": "云端照片1",
  "CloudPhotos_LowQuality": "云端照片2",
  "ScreenShot": "截图",
};



Future<Widget> album() async{
  return Row(
    children: [
      //游戏区
      Expanded(
        child: Column(
          children: [
            //分割线
            rui.divideLine,

            //工具栏
            SizedBox(
              height: topBarHeight,
              child: Container(
                color: Color(defaultViceColor),
                child: Row(
                  children: [
                    //相册选择按钮
                    rui.MultiValueListenableBuilder(
                      listenables: [isSelectAlbum, currentAlbum],
                      builder: (BuildContext context, List<Object?> values){
                        final bool isSelect = values[0] as bool;
                        final String? album = values[1] as String?;
                        return Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: TextButton(
                            onPressed: (){
                              //若选择了account, 切换相册选择面板
                              if(album != null){
                                isSelectAlbum.value = !isSelectAlbum.value;
                              }
                              //否则打开账号选择器
                              else{
                                isSelectAlbum.value = false;
                                isSelectAccount.value = true;
                              }
                            },
                            style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, isSelected: isSelect),
                            child: Text(albumName[album] ?? "请先选择账号", style: TextStyle(color: Color(albumName[album] == null ? defaultWarningColor : defaultAntiColor))),
                          ),
                        );
                      },
                    ),

                    //跳转至文件夹按钮
                    IconButton(
                      icon: Image.asset("assets/icon/folder.webp", height: 16),
                      onPressed: (){api.openPath(_gamePath);},
                      style: rui.buttonStyle(borderRadius: 8),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.end, // 关键：将Row的子控件对齐到右侧
                            children: [
                              rui.block5W,
                              //排序方式切换按钮
                              ValueListenableBuilder(
                                valueListenable: isGamePartForward,
                                builder: (context, value, child){
                                  return IconButton(
                                    icon: Image.asset(value ? "assets/icon/time_forward.webp" : "assets/icon/time_reverse.webp", height: 16),
                                    onPressed: (){isGamePartForward.value = !isGamePartForward.value;},
                                    style: rui.buttonStyle(borderRadius: 8),
                                  );
                                }
                              ),
                              rui.block5W,
                              //减少图片展示列数按钮
                              IconButton(
                                icon: Image.asset("assets/icon/layout_minus.webp", height: 20),
                                onPressed: (){if(gameImageColumns.value > _minColumn) gameImageColumns.value--;},
                                style: rui.buttonStyle(borderRadius: 8),
                              ),
                              rui.block5W,
                              //增加图片展示列数按钮
                              IconButton(
                                icon: Image.asset("assets/icon/layout_plus.webp", height: 20),
                                onPressed: (){if(gameImageColumns.value < _maxColumn) gameImageColumns.value++;},
                                style: rui.buttonStyle(borderRadius: 8),
                              ),
                              rui.block5W,
                              //资源优化按钮
                              IconButton(
                                icon: Image.asset("assets/icon/repair.webp", height: 20),
                                onPressed: (){},
                                style: rui.buttonStyle(borderRadius: 8),
                              ),
                              rui.block5W,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //图片区
            Expanded(
              child: Container(
                color: Color(defaultBackColor),
                child: rui.MultiValueListenableBuilder(
                  listenables: [gameImageColumns, currentAlbum, refreshAlbum, isGamePartForward],
                  builder: (BuildContext context, List<Object?> values){
                    final int column = values[0] as int;
                    // final String? album = values[1] as String?;
                    //未选择account时进行提示
                    if(currentAccount.value == null){
                      return Center(
                        child: Text("请先选择游戏账号", style: TextStyle(color: Color(defaultHighLightColor))),
                      );
                    }
                    return FutureBuilder(
                      future: _initGameImgList(),
                      builder: (BuildContext context, AsyncSnapshot imgSnapshot){
                        if(imgSnapshot.connectionState == ConnectionState.done && imgSnapshot.hasData){
                          return GridView.builder(
                            cacheExtent: 500,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: column,
                              childAspectRatio: 16 / 9, //显示区域宽高相等
                            ),
                            itemCount: imgSnapshot.data!.length,
                            physics: BouncingScrollPhysics(),
                            // addAutomaticKeepAlives: false,
                            // addRepaintBoundaries: false,
                            itemBuilder: (BuildContext context, int index){
                              //图片路径
                              final String path = imgSnapshot.data![index].path;
                              return FutureBuilder(
                                future: _imageBytesCache(imgSnapshot.data![index]),
                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                    return GestureDetector(
                                      //单击切换图片是否放入中转站
                                      onTap: (){
                                        if(gameStationImage.value.containsKey(path)){
                                          gameStationImage.value = Map.from(gameStationImage.value)..remove(path);
                                        }else{
                                          gameStationImage.value = Map.from(gameStationImage.value)..[path] = true;
                                          isViewSmallImage.value = true;
                                        }
                                      },
                                      //右键浏览大图
                                      onSecondaryTap: (){_viewImage.build(path);},
                                      child: MouseRegion(
                                        //图片放入中转站, 鼠标移入浏览
                                        onEnter: (_){
                                          if(gameStationImage.value.containsKey(path)){
                                            gameStationImage.value[path] = true;
                                            isViewSmallImage.value = true;
                                          }
                                        },
                                        //图片放入中转站, 鼠标移出停止浏览
                                        onExit: (_){
                                          if(gameStationImage.value.containsKey(path)){
                                            gameStationImage.value[path] = false;
                                            isViewSmallImage.value = false;
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Image(
                                              image: MemoryImage(snapshot.data!),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.contain,
                                            ),
                                            rui.MultiValueListenableBuilder(
                                              listenables: [gameStationImage, isViewSmallImage],
                                              builder: (context, values){
                                                final Map<String, bool> images = values[0] as Map<String, bool>;
                                                return Container(
                                                  color: Color(images.containsKey(path) ? images[path]! ? 0x99000000 : 0xDD000000 : 0x00000000),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }else{
                                    return const CircularProgressIndicator();
                                  }
                                },
                              );
                            },
                          );

                        }else{
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ),

      //工具区
      SizedBox(
        width: sideBarWidth,
        child: Container(
          color: Color(defaultMainColor),
          child: Column(
            children: [
              Container(
                width: sideBarWidth,
                height: topBarHeight,
                padding: EdgeInsets.fromLTRB(7, 6, 7, 4),
                child: IconButton(
                  icon: Image.asset("assets/icon/refresh.webp", height: 20),
                  onPressed: (){refreshAlbum.value++;},
                  style: rui.buttonStyle(borderRadius: 8),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: rui.MultiValueListenableBuilder(
                      listenables: [gameStationImage, backupStationImage],
                      builder: (BuildContext context, List<Object?> values){
                        final Map<String, bool> gameTS = values[0] as Map<String, bool>;
                        final Map<String, bool> backupTS = values[1] as Map<String, bool>;
                        final bool isInTS = gameTS.isNotEmpty || backupTS.isNotEmpty;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //取消
                            _toolButton(isInTS, "取消", "assets/icon/close.webp", (){
                              //关闭中转站
                              gameStationImage.value = {};
                              backupStationImage.value = {};
                            }),

                            rui.btnDivider,
                            //全选
                            _toolButton(isInTS, "全选", "assets/icon/all.webp", (){
                              //当前为游戏区中转站
                              if(gameStation.selector != null){
                                gameStationImage.value = {for(var item in _gameImgList) item.path : false};
                              }
                              //当前为备份区中转站
                              else if(backupStation.selector != null){
                                backupStationImage.value = {for(var item in _backupList["image"]!) item.path : false};
                              }
                            }),
                            //反选
                            _toolButton(isInTS, "反选", "assets/icon/reverse.webp", (){
                              //当前为游戏区中转站
                              if(gameStation.selector != null){
                                // gameStationImage.value = {for(final item in _gameImgList.where((e) => !gameStationImage.value.containsKey(e.path))) item: true};
                                final pathList = _gameImgList.map((e) => e.path);
                                gameStationImage.value = {for(final item in pathList.toSet().difference(gameStationImage.value.keys.toSet())) item : false};
                              }
                              //当前为备份区中转站
                              else if(backupStation.selector != null){
                                // backupStationImage.value = {for(final item in _gameImgList.where((e) => !backupStationImage.value.containsKey(e.path))) item: true};
                                final pathList = _backupList["image"]!.map((e) => e.path);
                                backupStationImage.value = {for(final item in pathList.toSet().difference(backupStationImage.value.keys.toSet())) item : false};
                              }
                            }),

                            rui.btnDivider,
                            //备份 / 还原
                            _toolButton(isInTS, backupTS.isEmpty ? "备份" : "还原", backupTS.isEmpty ? "assets/icon/backup.webp" : "assets/icon/restore.webp", () async{
                              //判断中转站是否有内容
                              if(!isInTS){
                                api.writeErrorLog("album : Cannot back up or restore files. Because the station could not be found.");
                                return ;
                              }
                              final Iterable<String> from = gameTS.isEmpty ? backupTS.keys : gameTS.keys;
                              final String to = gameTS.isEmpty ? _gamePath : _backupPath;

                              int counter = 0;
                              final int len = from.length;
                              try{
                                final dir = Directory(to);
                                if(! await dir.exists()){
                                  await dir.create(recursive: true);
                                }
                                for(var path in from){
                                  counter++;
                                  _progressBar.set(counter / len);
                                  await File(path).copy("$to${api.pathSymbol()}${api.pathLast(path)}");
                                }
                              }catch(e){
                                api.writeErrorLog("album : Backing up or restoring was interrupted. Because : $e");
                                _progressBar.close();
                              }
                              //关闭中转站, 并刷新相册
                              gameStationImage.value = {};
                              backupStationImage.value = {};
                              refreshAlbum.value++;
                            }),
                            //转移, NikkiPhotos相册转移后删除NikkiPhotos_LowQuality与ScreenShot的照片
                            _toolButton(isInTS, "转移", "assets/icon/move.webp", () async{
                              //判断中转站是否有内容
                              if(!isInTS){
                                api.writeErrorLog("album : Cannot move files. Because the station could not be found.");
                                return ;
                              }
                              final Iterable<String> from = gameTS.isEmpty ? backupTS.keys : gameTS.keys;
                              final String to = gameTS.isEmpty ? _gamePath : _backupPath;

                              int counter = 0;
                              final int len = from.length;
                              try{
                                final dir = Directory(to);
                                if(! await dir.exists()){
                                  await dir.create(recursive: true);
                                }
                                for(var path in from){
                                  counter++;
                                  _progressBar.set(counter / len);
                                  final file = File(path);
                                  await file.copy("$to${api.pathSymbol()}${api.pathLast(path)}");
                                  await file.delete();

                                  //对游戏的NikkiPhotos_HighQuality, NikkiPhotos_LowQuality与ScreenShot相册进行检测
                                  if(gameTS.isNotEmpty){
                                    //NikkiPhotos_LowQuality
                                    final lowPath = "${api.extractPath(path, 2)}${api.pathSymbol()}NikkiPhotos_LowQuality${api.pathSymbol()}${api.pathLast(path)}";
                                    final lowFile = File(lowPath);
                                    if(await lowFile.exists()) lowFile.delete();
                                    //ScreenShot
                                    final shotPath = "${api.extractPath(path, 5)}${api.pathSymbol()}ScreenShot${api.pathSymbol()}${api.pathLast(path)}";
                                    final shotFile = File(shotPath);
                                    if(await shotFile.exists()) shotFile.delete();
                                  }
                                }
                              }catch(e){
                                api.writeErrorLog("album : Backing up or restoring was interrupted. Because : $e");
                                _progressBar.close();
                              }
                              //关闭中转站, 并刷新相册
                              gameStationImage.value = {};
                              backupStationImage.value = {};
                              refreshAlbum.value++;
                            }),
                            //删除, NikkiPhotos相册需同时删除NikkiPhotos_HighQuality, NikkiPhotos_LowQuality与ScreenShot的照片
                            _toolButton(isInTS, "删除", "assets/icon/delete.webp", () async{
                              //判断中转站是否有内容
                              if(!isInTS){
                                api.writeErrorLog("album : Cannot delete files. Because the station could not be found.");
                                return ;
                              }
                              final Iterable<String> from = gameTS.isEmpty ? backupTS.keys : gameTS.keys;

                              int counter = 0;
                              final int len = from.length;
                              try{
                                for(var path in from){
                                  counter++;
                                  _progressBar.set(counter / len);
                                  await File(path).delete();

                                  //对游戏的NikkiPhotos_HighQuality, NikkiPhotos_LowQuality与ScreenShot相册进行检测
                                  if(gameTS.isNotEmpty){
                                    //NikkiPhotos_LowQuality
                                    final lowPath = "${api.extractPath(path, 2)}${api.pathSymbol()}NikkiPhotos_LowQuality${api.pathSymbol()}${api.pathLast(path)}";
                                    final lowFile = File(lowPath);
                                    if(await lowFile.exists()) lowFile.delete();
                                    //ScreenShot
                                    final shotPath = "${api.extractPath(path, 5)}${api.pathSymbol()}ScreenShot${api.pathSymbol()}${api.pathLast(path)}";
                                    final shotFile = File(shotPath);
                                    if(await shotFile.exists()) shotFile.delete();
                                  }
                                }
                              }catch(e){
                                api.writeErrorLog("album : Deleting File was interrupted. Because : $e");
                                _progressBar.close();
                              }
                              _progressBar.close();  //防止错误
                              //关闭中转站, 并刷新相册
                              gameStationImage.value = {};
                              backupStationImage.value = {};
                              refreshAlbum.value++;
                            }, isAccident: true),

                            rui.btnDivider,
                            // TODO 复制
                            // _toolButton(isInTS, "复制", "assets/icon/copy.webp", (){}),
                            _toolButton(false, "复制", "assets/icon/copy.webp", (){}),
                            // TODO 剪切
                            // _toolButton(isInTS, "剪切", "assets/icon/shear.webp", (){}),
                            _toolButton(false, "剪切", "assets/icon/shear.webp", (){}),

                            rui.btnDivider,
                            // TODO 撤销
                            _toolButton(false, "撤销", "assets/icon/undo.webp", (){}),
                            // TODO 重做
                            _toolButton(false, "重做", "assets/icon/redo.webp", (){}),

                            rui.btnDivider,
                            // TODO 帮助
                            _toolButton(true, "帮助", "assets/icon/help.webp", (){
                              rui.webview.url(r"https://www.bilibili.com/");}),

                          ],
                        );
                      },
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),

      //备份区
      Expanded(
        child: Column(
          children: [
            //分割线
            rui.divideLine,

            //
            SizedBox(
              height: topBarHeight,
              child: Container(
                color: Color(defaultViceColor),
                child: Row(
                  children: [
                    //备份目录路径显示区, 若用户还没有选择会显示备份路径选择按钮
                    Expanded(
                      child: ValueListenableBuilder<String?>(
                        valueListenable: backupFolderPath,
                        builder: (context, value, child){
                          return Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment.centerLeft,
                            child: Tooltip(
                              message: value == null ? "" : "若需要更改备份文件夹, 请前往设置进行更改",
                              exitDuration: Duration.zero,
                              waitDuration: const Duration(milliseconds: 500),
                              child: TextButton.icon(
                                icon: Image.asset("assets/icon/folder.webp", height: 16),
                                label: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(value ?? "请先选择你需要将相册备份的地方", style: TextStyle(color: Color(value == null ? defaultWarningColor : defaultAntiColor))),
                                ),
                                onPressed: () async{
                                  //若用户还没有选择备份目录, 点击按钮后会进行选择
                                  if(value == null){
                                    String? dir = await FilePicker.platform.getDirectoryPath();
                                    if(dir != null){
                                      backupFolderPath.value = dir;
                                      //保存配置
                                      save((){config["backupFolderPath"] = dir;});
                                    }
                                  }
                                  //若用户已经选择了备份目录, 点击按钮会打开该文件夹
                                  else{
                                    api.openPath(value);
                                  }
                                },
                                style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5),
                              ),
                            )
                          );
                        }
                      ),
                    ),
                    //排序方式切换按钮
                    ValueListenableBuilder(
                      valueListenable: isBackupPartForward,
                      builder: (context, value, child){
                        return IconButton(
                          icon: Image.asset(value ? "assets/icon/time_forward.webp" : "assets/icon/time_reverse.webp", height: 16),
                          onPressed: (){isBackupPartForward.value = !isBackupPartForward.value;},
                          style: rui.buttonStyle(borderRadius: 8),
                        );
                      }
                    ),
                    rui.block5W,
                    //减少图片展示列数按钮
                    IconButton(
                      icon: Image.asset("assets/icon/layout_minus.webp", height: 20),
                      onPressed: (){if(backupImageColumns.value > _minColumn) backupImageColumns.value--;},
                      style: rui.buttonStyle(borderRadius: 8),
                    ),
                    rui.block5W,
                    //增加图片展示列数按钮
                    IconButton(
                      icon: Image.asset("assets/icon/layout_plus.webp", height: 20),
                      onPressed: (){if(backupImageColumns.value < _maxColumn) backupImageColumns.value++;},
                      style: rui.buttonStyle(borderRadius: 8),
                    ),
                    rui.block5W,
                  ],
                ),
              ),
            ),

            //图片区
            Expanded(
              child: Container(
                color: Color(defaultBackColor),
                child: rui.MultiValueListenableBuilder(
                  listenables: [backupImageColumns, currentAlbum, backupFolderPath, isShowGroupList, currentBackupGroup, refreshAlbum],
                  builder: (BuildContext context, List<Object?> values){
                    final int column = values[0] as int;
                    // final String? album = values[1] as String?;
                    // final String? backup = values[2] as String?;
                    final bool isShowGroup = values[3] as bool;
                    final String? group = values[4] as String?;

                    //未设置备份路径时进行提示
                    if(backupFolderPath.value == null){
                      return Center(
                        child: Text("请先设置备份目录", style: TextStyle(color: Color(defaultHighLightColor))),
                      );
                    }
                    //未选择account时进行提示
                    else if(currentAccount.value == null){
                      return Center(
                        child: Text("请先选择游戏账号", style: TextStyle(color: Color(defaultHighLightColor))),
                      );
                    }
                    return FutureBuilder(
                      future: _initBackupImgList(backupFolderPath.value!, group: currentBackupGroup.value),
                      builder: (BuildContext context, AsyncSnapshot imgSnapshot){
                        if(imgSnapshot.connectionState == ConnectionState.done && imgSnapshot.hasData){
                          final List imageList = imgSnapshot.data!["image"];
                          final List groupList = imgSnapshot.data!["group"];
                          return Column(
                            children: [
                              SizedBox(
                                height: isShowGroup ? 80 : 0,
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 90,
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: group == null ? groupList.length + 1 : 4,  //返回, 重命名, 更改颜色, 解散分组
                                  // addAutomaticKeepAlives: false,
                                  // addRepaintBoundaries: false,
                                  itemBuilder: (BuildContext context, int index){
                                    //未选中group时, 展示所有group和添加分组按钮
                                    if(group == null){
                                      if(index == groupList.length){

                                        //创建分组按钮
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                onPressed: () async{
                                                  print(_backupPath);
                                                  try{
                                                    final dir = Directory(_backupPath);
                                                    int index = 1;
                                                    while(true){
                                                      final folderName = "分组$index";
                                                      final newDir = Directory("${dir.path}${api.pathSymbol()}$folderName");

                                                      // 检查是否存在
                                                      final exists = await newDir.exists();
                                                      if(!exists){
                                                        await newDir.create(recursive: true);
                                                        break;
                                                      }
                                                      index++;
                                                    }
                                                  }catch(e){
                                                    api.writeErrorLog("album : Cannot create a group folder. Because: ${e.toString()}");
                                                  }
                                                  //刷新
                                                  refreshAlbum.value++;
                                                },
                                                icon: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(Color(defaultHighLightColor), BlendMode.srcIn),
                                                  child: Image.asset("assets/icon/add.webp"),
                                                ),
                                                style: rui.buttonStyle(borderRadius: 5),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: IgnorePointer(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("创建分组", style: TextStyle(color: Color(defaultAntiColor)), maxLines: 1, softWrap: false, overflow: TextOverflow.visible),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      //group按钮, 点击进入group目录
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: Stack(
                                          children: [
                                            IconButton(
                                              onPressed: (){
                                                currentBackupGroup.value = api.pathLast(groupList[index].path);
                                              },
                                              icon: ColorFiltered(
                                                colorFilter: ColorFilter.mode(Color(defaultHighLightColor), BlendMode.srcIn),
                                                child: Image.asset("assets/icon/group.webp"),
                                              ),
                                              style: rui.buttonStyle(borderRadius: 5),
                                            ),
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Center(
                                                child: IgnorePointer(
                                                  child: Text(api.pathLast(groupList[index].path), style: TextStyle(color: Color(defaultAntiColor))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    //选中group时, 显示"返回", "重命名", "更改图标颜色", "解散分组"按钮
                                    else{
                                      //返回按钮
                                      if(index == 0){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                onPressed: (){
                                                  currentBackupGroup.value = null;
                                                },
                                                icon: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(Color(defaultHighLightColor), BlendMode.srcIn),
                                                  child: Image.asset("assets/icon/exit.webp"),
                                                ),
                                                style: rui.buttonStyle(borderRadius: 5),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: IgnorePointer(
                                                    child: Text("返回", style: TextStyle(color: Color(defaultAntiColor))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      //重命名按钮
                                      if(index == 1){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                onPressed: (){},
                                                icon: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(Color(defaultHighLightColor), BlendMode.srcIn),
                                                  child: Image.asset("assets/icon/group.webp"),
                                                ),
                                                style: rui.buttonStyle(borderRadius: 5, hoveredColorOpacity: 0),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: IgnorePointer(
                                                    child: Text("${currentBackupGroup.value}", style: TextStyle(color: Color(defaultAntiColor))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      //更改图标颜色按钮
                                      if(index == 2){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                onPressed: (){
                                                  _groupEditor.build();
                                                },
                                                icon: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(Color(defaultHighLightColor), BlendMode.srcIn),
                                                  child: Image.asset("assets/icon/setting.webp"),
                                                ),
                                                style: rui.buttonStyle(borderRadius: 5),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: IgnorePointer(
                                                    child: Text("更改信息", style: TextStyle(color: Color(defaultAntiColor))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      //解散分组按钮
                                      if(index == 3){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              Tooltip(
                                                message: "请长按按钮解散分组",
                                                waitDuration: Duration(milliseconds: 500),
                                                child: GestureDetector(
                                                  onLongPress: () async{
                                                    //将改group文件移动到group上级后, 删除group目录
                                                    try{
                                                      final group = Directory(_backupPath);
                                                      final files = await group.list(recursive: false).toList();

                                                      int count = 0;
                                                      final len = files.length;
                                                      for(var entity in files){
                                                        count++;
                                                        _progressBar.set(count / len);

                                                        final type = await FileSystemEntity.type(entity.path);
                                                        //只移动图像后缀的文件
                                                        if(type == FileSystemEntityType.file && _imageType.contains(entity.path.split(".").last.toLowerCase())){
                                                          await entity.rename("${api.extractPath(_backupPath, 1)}${api.pathSymbol()}${api.pathLast(entity.path)}");
                                                        }
                                                      }
                                                      await group.delete();
                                                    }catch(e){
                                                      api.writeErrorLog("album : Cannat dissolve the group. Because : $e");
                                                      _progressBar.close();
                                                    }

                                                    _progressBar.close();
                                                    currentBackupGroup.value = null;
                                                    refreshAlbum.value++;

                                                  },
                                                  child: IconButton(
                                                    onPressed: (){},
                                                    icon: ColorFiltered(
                                                      colorFilter: ColorFilter.mode(Color(defaultHighLightColor), BlendMode.srcIn),
                                                      child: Image.asset("assets/icon/dissolve.webp"),
                                                    ),
                                                    style: rui.buttonStyle(borderRadius: 5),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: IgnorePointer(
                                                    child: Text("解散分组", style: TextStyle(color: Color(defaultAntiColor))),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                    return Container();
                                  }
                                ),
                              ),
                              rui.divideLine,
                              SizedBox(
                                width: double.infinity,
                                height: 0.6 * topBarHeight,
                                child: IconButton(
                                  onPressed: (){isShowGroupList.value = !isShowGroupList.value;},
                                  icon: Image.asset(isShowGroup ? "assets/icon/fold.webp" : "assets/icon/expand.webp"),
                                  style: rui.buttonStyle(color: defaultViceColor, colorOpacity: 1),
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  cacheExtent: 500,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: column,
                                    childAspectRatio: 16 / 9,
                                  ),
                                  itemCount: imageList.length,
                                  physics: BouncingScrollPhysics(),
                                  // addAutomaticKeepAlives: false,
                                  // addRepaintBoundaries: false,
                                  itemBuilder: (BuildContext context, int index){
                                    //图片路径
                                    final String path = imageList[index].path;
                                    return FutureBuilder(
                                      future: _imageBytesCache(imageList[index]),
                                      builder: (BuildContext context, AsyncSnapshot snapshot){
                                        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                          return GestureDetector(
                                            //单击切换图片是否放入中转站
                                            onTap: (){
                                              if(backupStationImage.value.containsKey(path)){
                                                backupStationImage.value = Map.from(backupStationImage.value)..remove(path);
                                              }else{
                                                backupStationImage.value = Map.from(backupStationImage.value)..[path] = true;
                                                isViewSmallImage.value = true;
                                              }
                                            },
                                            //右键浏览大图
                                            onSecondaryTap: (){_viewImage.build(path);},
                                            child: MouseRegion(
                                              //图片放入中转站, 鼠标移入浏览
                                              onEnter: (_){
                                                if(backupStationImage.value.containsKey(path)){
                                                  backupStationImage.value[path] = true;
                                                  isViewSmallImage.value = true;
                                                }
                                              },
                                              //图片放入中转站, 鼠标移出停止浏览
                                              onExit: (_){
                                                if(backupStationImage.value.containsKey(path)){
                                                  backupStationImage.value[path] = false;
                                                  isViewSmallImage.value = false;
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Image(
                                                    image: MemoryImage(snapshot.data!),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  rui.MultiValueListenableBuilder(
                                                    listenables: [backupStationImage, isViewSmallImage],
                                                    builder: (context, values){
                                                      final Map<String, bool> images = values[0] as Map<String, bool>;
                                                      return Container(
                                                        color: Color(images.containsKey(path) ? images[path]! ? 0x99000000 : 0xDD000000 : 0x00000000),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }else{
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    );
                                  },
                                )
                              ),
                            ],
                          );
                        }else{
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  },
                )
              ),
            ),
          ],
        ),
      ),
    ],
  );
}



late String _gamePath;
late List _gameImgList;
///获取游戏区的相册
Future<List> _initGameImgList() async{
  _gameImgList = [];

  //根目录
  late final String root;

  //获取account信息, 未选择account时返回
  if(currentAccount.value == null) return _gameImgList;
  final account = currentAccount.value!;
  final version = account.split(" > ")[0];
  final uid = account.split(" > ")[1];

  //获取搜寻到的accountList
  List accountList = await api.getINAccountList();
  //合并用户自定义的accountList
  accountList +=
  await api.getINAccountList(targetDirs: config["customAccount"], pre: "_");

  //获取根目录
  final Map? accountMap = accountList.firstWhere(
      (map) => map["source"] == version,
    orElse: () => null,
  );
  //获取根目录失败, 退出
  if(accountMap == null){
    return _gameImgList;
  }
  root = accountMap["rootPath"]!;

  if(Platform.isWindows){
    switch(currentAlbum.value){
    //ScreenShot 无需uid
      case "ScreenShot":
        _gamePath = INFolderPaths["Windows"]!["ScreenShot"]!.replaceAll(r"$root$", root);
        break;
    //NikkiPhotos 需要定位到 NikkiPhotos_HighQuality
      case "NikkiPhotos":
        if(uid == "") return _gameImgList;
        _gamePath = INFolderPaths["Windows"]!["NikkiPhotos_HighQuality"]!.replaceAll(r"$root$", root).replaceAll(r"$uid$", uid);
        break;
      default:
        if(uid == "") return _gameImgList;
        _gamePath = INFolderPaths["Windows"]![currentAlbum.value]!.replaceAll(r"$root$", root).replaceAll(r"$uid$", uid);
        break;
    }

    //获取相册目录
    final dir = Directory(_gamePath);
    //判断相册目录是否存在
    if(! await dir.exists()){
      return _gameImgList;
    }

    //获取文件列表
    final files = await dir.list(recursive: false).toList();
    //云端相册文件夹有 CloudPhotos_LowQuality 与 CloudPhotos 并且都可能有temp子文件夹
    for(var entity in files){
      final type = await FileSystemEntity.type(entity.path);
      //若为文件, 判断后缀名, 正确则直接添加. 一般为jpeg
      if(type == FileSystemEntityType.file && _imageType.contains(entity.path.split(".").last.toLowerCase())){
        _gameImgList.add(entity);
      }
      //目录取内部的图片来添加
      else if(type == FileSystemEntityType.directory){
        final tempFiles = await Directory(entity.path).list(recursive: false).toList();
        for(var tempEntity in tempFiles){
          if(await FileSystemEntity.type(tempEntity.path) == FileSystemEntityType.file && _imageType.contains(tempEntity.path.split(".").last.toLowerCase())){
            _gameImgList.add(tempEntity);
          }
        }
      }
    }
  }else if(Platform.isAndroid){
    //一般为jpg文件
  }

  _gameImgList = api.sortByTimeName(_gameImgList, isDesc: !isGamePartForward.value);
  return _gameImgList;
}


late String _backupPath;
late Map<String, List> _backupList;
///获取备份区的相册
Future<Map<String, List>> _initBackupImgList(String? root, {String? group}) async{
  _backupList = {"image": [], "group": []};

  if(root == null) return _backupList;

  //获取account信息, 未选择account时返回
  if(currentAccount.value == null) return _backupList;
  final account = currentAccount.value!;
  final version = account.split(" > ")[0];
  final uid = account.split(" > ")[1];

  if(Platform.isWindows){
    switch(currentAlbum.value){
    //ScreenShot 无需uid
      case "ScreenShot":
        _backupPath = backupFolderPaths["Windows"]!["ScreenShot"]!.replaceAll(r"$root$", root).replaceAll(r"$version$", version);
        break;
      default:
        if(uid == "") return _backupList;
        _backupPath = backupFolderPaths["Windows"]![currentAlbum.value]!.replaceAll(r"$root$", root).replaceAll(r"$version$", version).replaceAll(r"$uid$", uid);
        break;
    }

    //若有group, 则定位到group目录
    if(group != null){
      _backupPath += "\\$group";
    }

    //获取相册目录
    final dir = Directory(_backupPath);
    //判断相册目录是否存在
    if(! await dir.exists()){
      return _backupList;
    }

    //获取文件列表
    final files = await dir.list(recursive: false).toList();
    //云端相册文件夹有 CloudPhotos_LowQuality 与 CloudPhotos 并且都可能有temp子文件夹
    for(var entity in files){
      final type = await FileSystemEntity.type(entity.path);
      //若为文件, 判断后缀名, 正确则直接添加. 一般为jpeg
      if(type == FileSystemEntityType.file && _imageType.contains(entity.path.split(".").last.toLowerCase())){
        _backupList["image"]!.add(entity);
      }
      //若为目录, 则添加到groupList. 如果已经位于group目录, 则忽略
      else if(type == FileSystemEntityType.directory && group == null){
        _backupList["group"]!.add(entity);
      }
    }
  }else if(Platform.isAndroid){
    //一般为jpg文件
  }

  return _backupList;
}



///工具区按钮
Widget _toolButton(bool isCanUse, String message, String img, Function() trigger, {bool isAccident = false}){
  return Tooltip(
    message: isCanUse ? isAccident ? "$message\n请长按" : message : "",
    child: GestureDetector(
      onLongPress: isAccident ? trigger : null,
      child: IconButton(
        icon: ColorFiltered(
          colorFilter: ColorFilter.mode(Color(isCanUse ? defaultAntiColor : defaultHighLightColor), BlendMode.srcIn),
          child: Image.asset(img, height: 20),
        ),
        onPressed: isAccident ? (){} : trigger,
        style: rui.buttonStyle(borderRadius: 8, hoveredColorOpacity: isCanUse ? 1 : 0),
      ),
    ),
  );
}


const _max = 300;
const _imageBytesCacheMax = 1000;
Map _imageBytesCacheList = {};
///照片缓存
Future _imageBytesCache(FileSystemEntity file) async{
  if(_imageBytesCacheList.containsKey(file.path)){
    return _imageBytesCacheList[file.path];
  }else{
    final imgFile = file as File;
    if(! await imgFile.exists()){
      return null;
    }
    final bytes = await imgFile.readAsBytes();
    //获取大小
    // final codec = await instantiateImageCodec(bytes);
    // final frame = await codec.getNextFrame();
    // final image = frame.image;
    // final width = image.width.toDouble();
    // final height = image.height.toDouble();
    // final maxLen = width > height ? width : height;
    // final double scale = _max / maxLen;

    //解码
    // final thumbnailBytes = api.getResizedImageData(originalImageProvider: MemoryImage(bytes), targetWidth: (width * scale).toInt(), targetHeight: (height * scale).toInt());
    final thumbnailBytes = api.getResizedImageData(originalImageProvider: MemoryImage(bytes), targetWidth: 320, targetHeight: 180);
    final keys = _imageBytesCacheList.keys.toList();
    if(keys.length > _imageBytesCacheMax){
      _imageBytesCacheList.remove(keys.first);
    }else if(keys.length < _imageBytesCacheMax){
      _imageBytesCacheList[file.path] = thumbnailBytes;
    }
    return thumbnailBytes;
  }
}



///相册选择框
abstract class albumSelector{
  // static ValueNotifier<bool> notifier = _isSelectAlbum;
  static OverlayEntry? selector;

  static Future<void> init() async{

  }

  static Future<void> build() async{
    if(selector != null){
      close();
    }
    await init();

    selector = OverlayEntry(
      builder: (context){
        return Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){isSelectAlbum.value = false;},
              ),
            ),
            Positioned(
              top: topBarHeight * 2 + 2,
              left: sideBarWidth + 2,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 200,
                height: 225,
                decoration: rui.borderStyle(),
                child: ListView.builder(
                  //未选择account, 提示选择.未选择uid, 只有截图相册,并提示选择uid
                  itemCount: currentAccount.value!.split(" > ")[1] == "" ? 2 : albumName.length,
                  itemExtent: topBarHeight,
                  itemBuilder: (BuildContext context, int index){
                    //未选择uid, 只显示截图相册
                    if(currentAccount.value!.split(" > ")[1] == "" && index == 0){
                      return SizedBox(
                        height: topBarHeight,
                        child: TextButton(
                          onPressed: (){
                            currentAlbum.value = "ScreenShot";
                            isSelectAlbum.value = false;
                          },
                          style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, colorOpacity: 0),
                          child: Text(albumName["ScreenShot"]!, style: TextStyle(color: Color(defaultAntiColor))),
                        ),
                      );
                    }
                    //未选择uid, 提示, 点击按钮后打开account选择器
                    else if(currentAccount.value!.split(" > ")[1] == "" && index == 1){
                      return SizedBox(
                        height: topBarHeight,
                        child: TextButton(
                          onPressed: (){
                            isSelectAlbum.value = false;
                            isSelectAccount.value = true;
                          },
                          style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, colorOpacity: 0),
                          child: Text("选择uid后查看更多相册", style: TextStyle(color: Color(defaultAntiColor))),
                        ),
                      );
                    }
                    //相册选择按钮
                    return SizedBox(
                      height: topBarHeight,
                      child: TextButton(
                        onPressed: (){
                          currentAlbum.value = albumName.keys.toList()[index];
                          isSelectAlbum.value = false;
                        },
                        style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5),
                        child: Text(albumName[albumName.keys.toList()[index]]!, style: TextStyle(color: Color(defaultAntiColor))),
                      ),
                    );
                  }
                ),
              )
            )
          ],
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  static void close(){
    if(selector == null){
      return;
    }

    selector!.remove();
    selector = null;
  }
}



///游戏区中转站
abstract class gameStation{
  // static ValueNotifier<bool> notifier = gameStationImage;

  static OverlayEntry? selector;

  static Future<void> init() async{

  }

  static Future<void> build() async{
    if(selector != null){
      close();
    }
    await init();

    selector = OverlayEntry(
      builder: (context){
        return Positioned(
          left: sideBarWidth * 2,
          top: topBarHeight + 2,
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              const Expanded(child: Center(),),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: topBarHeight,
                      color: Color(defaultViceColor),
                      child: Center(
                        child: Text(currentBackupGroup.value == null ? "中转站" : "中转站 > ${currentBackupGroup.value}", style: TextStyle(color: Color(defaultAntiColor), fontSize: 16, decoration: TextDecoration.none)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Color(defaultBackColor),
                        child: rui.MultiValueListenableBuilder(
                          listenables: [gameImageColumns, gameStationImage],
                          builder: (BuildContext context, List<Object?> values){
                            final int column = values[0] as int;
                            final Map image = values[1] as Map;

                            return GridView.builder(
                              cacheExtent: 500,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: column,
                                childAspectRatio: 16 / 9,
                              ),
                              itemCount: image.length,
                              physics: BouncingScrollPhysics(),
                              // addAutomaticKeepAlives: false,
                              // addRepaintBoundaries: false,
                              itemBuilder: (BuildContext context, int index){
                                final String path = image.keys.toList()[index];
                                return FutureBuilder(
                                  future: _imageBytesCache(File(path)),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                      return GestureDetector(
                                        //单击将图片移出中转站
                                        onTap: (){
                                          gameStationImage.value = Map.from(gameStationImage.value)..remove(path);
                                        },
                                        //右键浏览大图
                                        onSecondaryTap: (){_viewImage.build(path);},
                                        child: Image(
                                          image: MemoryImage(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }else{
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                );
                              }
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  static void close(){
    if(selector == null){
      return;
    }

    selector!.remove();
    selector = null;
  }
  
}



///备份区中转站
abstract class backupStation{
  // static ValueNotifier<bool> notifier = backupStationImage;

  static OverlayEntry? selector;

  static Future<void> init() async{

  }

  static Future<void> build() async{
    if(selector != null){
      close();
    }
    await init();

    selector = OverlayEntry(
      builder: (context){
        return Positioned(
          left: sideBarWidth,
          top: topBarHeight + 2,
          right: sideBarWidth,
          bottom: 0,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: topBarHeight,
                      color: Color(defaultViceColor),
                      child: Center(
                        child: Text("中转站", style: TextStyle(color: Color(defaultAntiColor), fontSize: 16, decoration: TextDecoration.none)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Color(defaultBackColor),
                        child: rui.MultiValueListenableBuilder(
                          listenables: [backupImageColumns, backupStationImage],
                          builder: (BuildContext context, List<Object?> values){
                            final int column = values[0] as int;
                            final Map image = values[1] as Map;

                            return GridView.builder(
                              cacheExtent: 500,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: column,
                                childAspectRatio: 16 / 9,
                              ),
                              itemCount: image.length,
                              physics: BouncingScrollPhysics(),
                              // addAutomaticKeepAlives: false,
                              // addRepaintBoundaries: false,
                              itemBuilder: (BuildContext context, int index){
                                final String path = image.keys.toList()[index];
                                return FutureBuilder(
                                  future: _imageBytesCache(File(path)),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                      return GestureDetector(
                                        //单击将图片移出中转站
                                        onTap: (){
                                          backupStationImage.value = Map.from(backupStationImage.value)..remove(path);
                                        },
                                        //右键浏览大图
                                        onSecondaryTap: (){_viewImage.build(path);},
                                        child: Image(
                                          image: MemoryImage(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }else{
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                );
                              }
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: Center()),
            ],
          ),
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  static void close(){
    if(selector == null){
      return;
    }

    selector!.remove();
    selector = null;
  }

}



///group信息编辑框
abstract class _groupEditor{
  // static ValueNotifier<bool> notifier = _isSelectAlbum;
  static OverlayEntry? selector;

  //编辑区的名称值
  static late ValueNotifier<String> _editName;
  static late TextEditingController _nameController;
  static late bool _isRepeat;

  static Future<void> init() async{
    _editName = ValueNotifier<String>("");
    _nameController = TextEditingController(text: "${currentBackupGroup.value}");
    _isRepeat = false;
  }

  static Future<void> build() async{
    if(selector != null){
      close();
    }
    await init();

    selector = OverlayEntry(
      builder: (context){
        return Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){close();},
              ),
            ),
            Positioned(
              top: topBarHeight * 2 + 2,
              right: sideBarWidth + 2,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 200,
                height: 250,
                decoration: rui.borderStyle(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: topBarHeight,
                      child: TextButton.icon(
                        icon:  Image.asset("assets/icon/group.webp", height: topBarHeight - 20),
                        label: Text("图标", style: TextStyle(color: Color(defaultAntiColor))),
                        onPressed: (){},
                        style: rui.buttonStyle(borderRadius: 8),
                      ),
                    ),

                    //名称输入框
                    Material(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                        color: Color(defaultMainColor),
                        child: ValueListenableBuilder(
                          valueListenable: _editName,
                          builder: (context, title, child){
                            return rui.textInput(
                              "名称",
                              "请输入分组名称",
                              (value) async{
                                _editName.value = value;
                                final dirs = await Directory(api.extractPath(_backupPath, 1)).list(recursive: false).toList();
                                _isRepeat = dirs.any((e) => api.pathLast(e.path) == _editName.value);
                              },
                              controller: _nameController,
                              maxLength: 18,
                              error: _isRepeat ? "该名称已存在" : null,
                            );
                          }
                        ),
                      )
                    ),

                    rui.block5H,
                    //保存
                    SizedBox(
                      height: topBarHeight,
                      child: TextButton(
                        onPressed: () async{
                          //若目录名重复, 则取消保存
                          if(_isRepeat) return;
                          try{
                            final dir = Directory(_backupPath);
                            await dir.rename("${api.extractPath(dir.path, 1)}${api.pathSymbol()}${_editName.value}");
                          }catch(e){
                            api.writeErrorLog("album : Cannot rename group. Because : $e");
                          }
                          close();
                          currentBackupGroup.value = _editName.value;
                          refreshAlbum.value++;
                        },
                        style: rui.buttonStyle(borderRadius: 8, minWidth: 188, color: defaultViceColor, colorOpacity: 1),
                        child: Text("保存", style: TextStyle(color: Color(defaultAntiColor))),
                      ),
                    ),
                    rui.block5H,
                    //取消
                    SizedBox(
                      height: topBarHeight,
                      child: TextButton(
                        onPressed: (){close();},
                        style: rui.buttonStyle(borderRadius: 8, minWidth: 188, color: defaultViceColor, colorOpacity: 1),
                        child: Text("取消", style: TextStyle(color: Color(defaultAntiColor))),
                      ),
                    ),

                  ],
                ),
              )
            )
          ],
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  static void close(){
    if(selector == null){
      return;
    }

    _editName.dispose();
    _nameController.dispose();

    selector!.remove();
    selector = null;
  }
}



///进度条
abstract class _progressBar{
  static OverlayEntry? selector;

  static late ValueNotifier<double> progress;

  //设置进度
  static void set(double p) async{
    p = p.clamp(0, 1);
    //若进度条不存在, 则创建
    if(selector == null && p != 1){
      build();
    }
    //当p=1时, 关闭进度条
    if(p != 1){
      progress.value = p;
    }else{
      close();
    }
  }

  static Future<void> init() async{
    progress = ValueNotifier<double>(0);
  }

  static Future<void> build() async{
    if(selector != null){
      close();
    }
    await init();

    selector = OverlayEntry(
      builder: (context){
        return Positioned(
          left: 0,
          top: topBarHeight + 2,
          right: 0,
          bottom: 0,
          child: Container(
            color: Color(0x99000000),
            child: Center(
              child: SizedBox(
                width: 300,
                height: 10,
                child: ValueListenableBuilder(
                  valueListenable: progress,
                  builder: (context, value, child){
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Color(defaultAntiColor),
                      color: Color(defaultHighLightColor),
                    );
                  }
                ),
              ),
            ),
          ),
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  static void close(){
    if(selector == null){
      return;
    }

    progress.dispose();

    selector!.remove();
    selector = null;
  }
}



///大图浏览
abstract class _viewImage{
  static OverlayEntry? selector;

  static Future<void> init() async{
  }

  static Future<void> build(String path) async{
    if(selector != null){
      close();
    }
    await init();

    selector = OverlayEntry(
      builder: (context){
        return Stack(
          children: [
            Positioned(
              left: sideBarWidth,
              top: topBarHeight + 2,
              right: 0,
              bottom: 0,
              child: ColoredBox(color: Color(0xAA000000)),
            ),
            Positioned(
              left: sideBarWidth,
              top: topBarHeight + 2,
              right: 0,
              bottom: 0,
              child: Image.file(File(path), fit: BoxFit.contain,),
            ),
            Positioned(
              top: topBarHeight,
              right: 0,
              bottom: 0,
              left: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){close();},
                onSecondaryTap: (){close();},
              ),
            ),
          ],
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  static void close(){
    if(selector == null){
      return;
    }

    selector!.remove();
    selector = null;
  }
}