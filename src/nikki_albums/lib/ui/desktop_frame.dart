import "package:nikki_albums/main.dart";
import "package:nikki_albums/pages/pages.dart";
import "package:nikki_albums/state.dart";
import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;
import "package:nikki_albums/api/api.dart" as api;

import "package:flutter/material.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:file_picker/file_picker.dart";


class mainWindow extends StatelessWidget{
  const mainWindow({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      // scrollBehavior: ,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WindowBorder(
          key: ancestor,
          color: Color(defaultMainColor),
          width: 1,
          child: const Column(
            children: [
              topBar(),
              content(),
            ],
          ),
        ),
      ),
    );
  }
}

class topBar extends StatelessWidget{
  const topBar({Key? key}):super(key: key);
  
  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: topBarHeight,
      child: Container(
        color: Color(defaultViceColor),
        child: Stack(
          children: [
            //窗口移动区
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: MoveWindow(),
            ),
            Row(
              children: [
                //窗口Icon
                 IgnorePointer(
                   ignoring: true,
                   child: Container(
                     padding: EdgeInsets.all(8),
                     width: sideBarWidth,
                     height: topBarHeight,
                     child: Image.asset("assets/logo/nikki_albums.webp", ),
                   ),
                 ),

                //版本或账号选择按钮
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: rui.MultiValueListenableBuilder(
                      listenables: [isSelectAccount, currentAccount, isWebview],
                      builder: (BuildContext context, List<Object?> values){
                        final bool isSelect = values[0] as bool;
                        final String? account = values[1] as String?;
                        final bool isWebview = values[2] as bool;
                        if(isWebview){
                          return Container();
                        }else{
                          return TextButton.icon(
                            icon:  Image.asset(
                              account == null ? "assets/icon/select.webp" : "assets/logo/${account.split(" > ")[0]}.png",
                              height: topBarHeight - 20,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace){
                                return Image.asset("assets/logo/defaultLogo.webp", width: topBarHeight - 20);
                              },
                            ),
                            label: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(account ?? "选择账号", overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Color(defaultAntiColor))),
                            ),
                            onPressed: (){isSelectAccount.value = !isSelectAccount.value;},
                            style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, isSelected: isSelect == true),
                          );
                        }
                      },
                    ),
                  ),
                ),
                // TODO 设置功能
                //设置
                IconButton(
                  icon: Image.asset("assets/icon/setting.webp", height: 20),
                  onPressed: (){
                    rui.tip.show(message: "$hint\n当前版本$version\n\n加入qq群: ${config["qq"]},可提出关于软件的优化建议, 反馈bug等, 也可以体验到该软件的最新版本\n\n软件官网还在开发中.....\n\n作者官网: https://ranaxro.github.io", url: "https://github.com/RanAxro/nikki_albums", urlMessage: "软件开源地址");
                  },
                  style: rui.buttonStyle(borderRadius: 8),
                ),
                rui.block10W,
                //置顶窗口按钮
                ValueListenableBuilder<bool>(
                  valueListenable: isTopWindow,
                  builder: (context, value, child){
                    return IconButton(
                      icon: Image.asset("assets/icon/top.webp", height: 20,),
                      onPressed: (){isTopWindow.value = !isTopWindow.value;},
                      style: rui.buttonStyle(borderRadius: 8, isSelected: value == true),
                    );
                  }
                ),
                rui.block10W,
                //最小化窗口按钮
                IconButton(
                  icon: Image.asset("assets/icon/minimize.webp", height: 13),
                  onPressed: (){appWindow.minimize();},
                  style: rui.buttonStyle(minWidth: topBarHeight + 10, minHeight: topBarHeight),
                ),
                //最小化窗口按钮
                IconButton(
                  icon: Image.asset("assets/icon/layout_minus.webp", height: 13),
                  onPressed: (){appWindow.maximizeOrRestore();},
                  style: rui.buttonStyle(minWidth: topBarHeight + 10, minHeight: topBarHeight),
                ),
                //关闭窗口按钮
                IconButton(
                  icon: Image.asset("assets/icon/close.webp", height: 13),
                  onPressed: (){appWindow.close();},
                  style: rui.buttonStyle(minWidth: topBarHeight + 10, minHeight: topBarHeight, hoveredColor: defaultWarningColor, hoveredColorOpacity: 0.7, pressedColor: defaultWarningColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void fn(){

}

class content extends StatelessWidget{
  const content({Key? key}):super(key: key);

  static const List pageList = [
    ["assets/logo/camera.png", camera],
    ["assets/logo/album.png", album],
    ["assets/logo/video.png", video],
    ["assets/logo/paper_tool.png", paper_tool],
    ["assets/logo/wiki.png", wiki],
    ["assets/logo/cdkey.png", cdkey],
    ["assets/logo/engineSetting.png", engineSetting],
  ];
  
  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Container(
        color: Color(defaultMainColor),
        child: Row(
          children: [
            SizedBox(
              width: sideBarWidth,
              child: ListView.builder(
                itemCount: pageList.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: ValueListenableBuilder<int>(
                      valueListenable: contentPage,
                      builder: (context, value, child){
                        return IconButton(
                          icon: Image.asset(pageList[index][0]),
                          onPressed: (){contentPage.value = index;},
                          style: rui.buttonStyle(borderRadius: 8, isSelected: value == index),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child:
              PageView.builder(
                controller: contentController,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return rui.KeepAliveWrapper(
                    child: FutureBuilder<Widget>(
                      future: pageList[index][1](),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return snapshot.data!;
                        }
                        return Container();
                      }
                    ),
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}



//account选项面板
abstract class accountSelector{
  // static ValueNotifier<bool> notifier = isSelectAccount;
  static OverlayEntry? selector;

  static const _editPage = 0;
  static const _versionSelectorPage = 1;
  static const _uidSelectorPage = 2;
  static late PageController _controller;

  //accountList
  static late ValueNotifier<List> _accountList;
  //初始化accountList
  static Future _initAccountList() async{
    _accountList.value = await api.getINAccountList();
    //合并accountList
    _accountList.value += await api.getINAccountList(targetDirs: config["customAccount"], pre: "_");
  }

  //被选中的version的index
  static late ValueNotifier<int?> _selectedVersionIndex;

  //编辑区的标题值
  static late ValueNotifier<String> _editTitle;

  //编辑区的路径值
  static late ValueNotifier<String?> _editPath;

  //保存自定义account
  static Future _saveCustomAccount() async{
    if(
      _editPath.value != null &&  //游戏根目录不能为空
      _editPath.value != r"$notExe$" &&
      _editPath.value != r"$notX6Game$" &&
      _editPath.value != r"$failed$" &&
      _editPath.value != r"$notLocated$" &&
      !config["customAccount"].any((e) => e["source"] == _editTitle.value)  //标题不能重复
    ){
      save((){
        config["customAccount"].add({"source": _editTitle.value, "rootPath": _editPath.value});
        _accountList.value.add({"source": _editTitle.value, "rootPath": _editPath.value});
      });
      _editTitle.value = "";
      _editPath.value = null;
      await _initAccountList();
      _controller.animateToPage(_versionSelectorPage, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    //游戏根目录不能为空
    else if(_editPath.value == null){
      _editPath.value = r"$notLocated$";
    }
  }

  static Future<void> init() async{
    _controller = PageController(initialPage: _versionSelectorPage);
    _accountList = ValueNotifier<List>([]);
    _selectedVersionIndex = ValueNotifier<int?>(null);
    _editTitle = ValueNotifier<String>("");
    _editPath = ValueNotifier<String?>(null);
    await _initAccountList();
  }

  //build
  static void build() async{
    if(selector != null){
      close();
    }
    await init();

    // _selectedVersionIndex.addListener((){
    //   _controller.animateToPage(_selectedVersionIndex.value == null ? _versionSelectorPage : _uidSelectorPage, duration: Duration(milliseconds: 300), curve: Curves.ease);
    // });
    selector = OverlayEntry(
      builder: (context){
        return Stack(
          children: [
            Positioned(
              top: topBarHeight + 2,
              right: 0,
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: (){isSelectAccount.value = false;},
              ),
            ),
            Positioned(
              top: topBarHeight + 2,
              left: sideBarWidth + 2,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 200,
                height: 4.5 * (topBarHeight) + 60,
                decoration: rui.borderStyle(),
                // decoration: BoxDecoration(
                //   color: Color(defaultMainColor), // 设置背景颜色
                //   borderRadius: BorderRadius.circular(12), // 设置圆角
                // ),
                child: PageView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    //editor
                    Column(
                      children: [
                        //标题输入框
                        Material(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                            color: Color(defaultMainColor),
                            child: ValueListenableBuilder(
                              valueListenable: _editTitle,
                              builder: (context, title, child){
                                return rui.textInput(
                                  "标题",
                                  "请输入标题",
                                  (value){_editTitle.value = value;},
                                  maxLength: 18,
                                  error: config["customAccount"].any((e) => e["source"] == title) ? "该标题已存在" : null,
                                );
                              }
                            ),
                          )
                        ),
                        rui.block5H,

                        //目录选择按钮
                        SizedBox(
                          height: topBarHeight,
                          child: GestureDetector(
                            //右键, 手动定位根目录
                            onSecondaryTap: () async{
                              final dir = await FilePicker.platform.getDirectoryPath();
                              if(dir != null){
                                if(dir.endsWith("X6Game")){
                                  _editPath.value = api.extractPath(dir, 2);
                                }else{
                                  _editPath.value = r"$notX6Game$";
                                }
                              }
                            },
                            child: TextButton.icon(
                              icon: Image.asset("assets/icon/folder.webp", width: topBarHeight - 20),
                              label: ValueListenableBuilder(
                                valueListenable: _editPath,
                                builder: (context, value, child){
                                  return Text(
                                    _editPath.value == null? "定位游戏" :
                                    _editPath.value == r"$notExe$"? "定位失败: 请选取exe文件" :
                                    _editPath.value == r"$notX6Game$"? "定位失败: 请选取X6Game文件夹" :
                                    _editPath.value == r"$failed$" ? "解析失败,请右键定位X6Game文件夹" :
                                    _editPath.value == r"$notLocated$" ? "请先定位游戏" : "定位成功",
                                    style: TextStyle(color: Color(_editPath.value == r"$notExe$" || _editPath.value == r"$failed$" || _editPath.value == r"$notX6Game$" || _editPath.value == r"$notLocated$" ? defaultWarningColor : defaultAntiColor))
                                  );
                                }
                              ),
                              onPressed: () async{
                                //选取exe文件
                                var file = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ["exe"],
                                  allowMultiple: false,
                                );
                                if(file != null){
                                  //选取了非.exe结尾发快捷方式
                                  if(!file.files.first.name.toLowerCase().endsWith(".exe")){
                                    _editPath.value = r"$notExe$";
                                  }else{
                                    //验证路径并得到根目录路径
                                    String? rootPath = await api.verifyINFile(file.files.first.path!);
                                    if(rootPath == null){
                                      //验证失败
                                      _editPath.value = r"$failed$";
                                    }else{
                                      _editPath.value = rootPath;
                                    }
                                  }
                                }
                              },
                              style: rui.buttonStyle(borderRadius: 8, minWidth: 188, alignment: Alignment.centerLeft),
                            ),
                          ),
                        ),
                        rui.block5H,

                        //保存按钮
                        SizedBox(
                          height: topBarHeight,
                          child: TextButton(
                            onPressed: (){_saveCustomAccount();},
                            style: rui.buttonStyle(borderRadius: 8, minWidth: 188, color: defaultViceColor, colorOpacity: 1),
                            child: Text("保存", style: TextStyle(color: Color(defaultAntiColor))),
                          ),
                        ),
                        rui.block5H,

                        //取消按钮
                        SizedBox(
                          height: topBarHeight,
                          child: TextButton(
                            onPressed: (){
                              _controller.animateToPage(_versionSelectorPage, duration: Duration(milliseconds: 300), curve: Curves.ease);
                              _editTitle.value = "";
                              _editPath.value = null;
                            },
                            style: rui.buttonStyle(borderRadius: 8, minWidth: 188, color: defaultViceColor, colorOpacity: 1),
                            child: Text("取消", style: TextStyle(color: Color(defaultAntiColor))),
                          ),
                        ),
                      ],
                    ),

                    //versionSelector
                    rui.KeepAliveWrapper(
                      child: ValueListenableBuilder(
                        valueListenable: _accountList,
                        builder: (context, value, child){
                          return ListView.builder(
                            itemCount: value.length + 1, // 列表的总项目数
                            itemExtent: topBarHeight,
                            itemBuilder: (BuildContext context, int index){
                              if(index == value.length){
                                //增加按钮
                                return SizedBox(
                                  height: topBarHeight,
                                  child: TextButton.icon(
                                    icon: Image.asset("assets/icon/add.webp", width: topBarHeight - 20, ),
                                    label: Text("添加", style: TextStyle(color: Color(defaultAntiColor))),
                                    onPressed: (){
                                      _controller.animateToPage(_editPage, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                    },
                                    style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, alignment: Alignment.centerLeft),
                                  ),
                                );
                              }
                              return SizedBox(
                                height: topBarHeight,
                                //长按右键删除用户自定义account
                                child: GestureDetector(
                                  onSecondaryLongPress: (){
                                    final customAccount = config["customAccount"];
                                    for(var account in customAccount){
                                      if(account["source"] == value[index]["source"].replaceAll(RegExp(r"_+$"), "")){
                                        customAccount.remove(account);
                                        save((){config["customAccount"] = customAccount;});
                                        break;
                                      }
                                    }
                                    _initAccountList();
                                  },
                                  child: Tooltip(
                                    message: value[index]["source"].endsWith("_") ? "长按右键删除" : "",
                                    exitDuration: Duration.zero,
                                    waitDuration: const Duration(milliseconds: 500),
                                    child: TextButton.icon(
                                      icon: Image.asset(
                                        "assets/logo/${value[index]["source"]}.png",
                                        width: topBarHeight - 20,
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace){
                                          return Image.asset("assets/logo/defaultLogo.webp", width: topBarHeight - 20);
                                        },
                                      ),
                                      label: Text("${value[index]["source"]}", style: TextStyle(color: Color(defaultAntiColor))),

                                      onPressed: (){
                                        _selectedVersionIndex.value = index;
                                        _controller.animateToPage(_uidSelectorPage, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                        //若无uid 则跳出
                                        if(value[index]["uidList"].length == 0){
                                          currentAccount.value = "${value[index]["source"]} > ";
                                          isSelectAccount.value = false;
                                        }
                                      },
                                      style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, alignment: Alignment.centerLeft),
                                    ),
                                  ),
                                ),
                              );
                            }
                          );
                        }
                      )
                    ),

                    //uidSelector
                    ValueListenableBuilder<int?>(
                      valueListenable: _selectedVersionIndex,
                      builder: (context, value, child){
                        return ListView.builder(
                          itemCount: _selectedVersionIndex.value == null ? 2 : _accountList.value[_selectedVersionIndex.value!]["uidList"].length + 1, // 列表的总项目数
                          itemExtent: topBarHeight,
                          itemBuilder: (BuildContext context, int index){
                            if(index == 0){
                              return SizedBox(
                                height: topBarHeight,
                                child: TextButton.icon(
                                  icon: Image.asset("assets/icon/return.webp", width: topBarHeight - 20, ),
                                  label: Text("返回", style: TextStyle(color: Color(defaultAntiColor)),),
                                  onPressed: (){_controller.animateToPage(_versionSelectorPage, duration: Duration(milliseconds: 300), curve: Curves.ease);},
                                  style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, alignment: Alignment.centerLeft),
                                ),
                              );
                            }
                            return SizedBox(
                              height: topBarHeight,
                              child: TextButton.icon(
                                icon: Icon(Icons.favorite),
                                label: Text(_accountList.value[_selectedVersionIndex.value!]["uidList"][index - 1], style: TextStyle(color: Color(defaultAntiColor)),),
                                onPressed: (){
                                  currentAccount.value = "${_accountList.value[_selectedVersionIndex.value!]["source"]} > ${_accountList.value[_selectedVersionIndex.value!]["uidList"][index - 1]}";
                                  isSelectAccount.value = false;
                                },
                                style: rui.buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5, alignment: Alignment.centerLeft),
                              ),
                            );
                          }
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
    Overlay.of(ancestor.currentContext!).insert(selector!);
  }

  //关闭account选项面板
  static void close(){
    if(selector == null){
      return;
    }

    _controller.dispose();
    _selectedVersionIndex.dispose();
    _editTitle.dispose();
    _editPath.dispose();

    selector!.remove();
    selector = null;
  }
}