import "dart:async";

import "package:nikki_albums/state.dart";
import "package:nikki_albums/constants.dart";

import "package:flutter/material.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";


const block5W = SizedBox(width: 5);
const block10W = SizedBox(width: 10);
const block5H = SizedBox(height: 5);
const block10H = SizedBox(height: 10);

const divideLine = Divider(
  height: 1,
  thickness: 1,
  color: Color(defaultBackColor),
);
const btnDivider = Divider(
  height: 15,
  thickness: 2,
  color: Color(defaultViceColor),
  indent: 10,
  endIndent: 10,
);

//按钮样式
ButtonStyle buttonStyle({
  double borderRadius = 0,
  double minWidth = 0,
  double minHeight = 0,
  double maxWidth = 1000,
  double maxHeight = 1000,
  int color = 0x00000000,
  double colorOpacity = 0,
  int hoveredColor = defaultHighLightColor,
  double hoveredColorOpacity = 0.5,
  int pressedColor = defaultHighLightColor,
  double pressedColorOpacity = 1,
  int selectedColor = defaultHighLightColor,
  double selectedColorOpacity = 1,
  bool isSelected = false,
  AlignmentGeometry? alignment,
}){
  return ButtonStyle(
      minimumSize: WidgetStateProperty.all<Size>(Size(minWidth, minHeight)),
      maximumSize: WidgetStateProperty.all<Size>(Size(maxWidth, maxHeight)),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))
    ),
    backgroundColor: WidgetStateProperty.all(isSelected ? Color(selectedColor).withValues(alpha: selectedColorOpacity) : Color(color).withValues(alpha: colorOpacity)),
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states){
        if(states.contains(WidgetState.hovered)){
          return Color(hoveredColor).withValues(alpha: hoveredColorOpacity);
        }else if(states.contains(WidgetState.pressed)){
          return Color(pressedColor).withValues(alpha: pressedColorOpacity);
        }else{
          return null;
        }
      }
    ),
    alignment: alignment
  );
}

//边框样式
BoxDecoration borderStyle({
  int color = defaultMainColor,
  double borderRadius = 12,
  int borderColor = defaultViceColor,
  double borderWidth = 1.5,
  int shadowColor = defaultBackColor,
  double shadowSpread = 1,
  double shadowBlur = 10,
  double shadowOffsetX = 0,
  double shadowOffsetY = 0,
}){
  return BoxDecoration(
    color: Color(color),
    borderRadius: BorderRadius.circular(borderRadius), // 设置圆角
    border: Border.all(
      color: Color(borderColor),
      width: borderWidth,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(shadowColor),
        spreadRadius: shadowSpread,
        blurRadius: shadowBlur,
        offset: Offset(shadowOffsetX, shadowOffsetY),
      ),
    ],
  );
}


//输入框
Widget textInput(
  String label,
  String hint,
  Function(String) onChanged,
  {
    int? maxLength,
    String? error,
    TextEditingController? controller,
  }
){
  return TextField(
    controller: controller,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error,
      labelStyle: TextStyle(color: Color(defaultAntiColor)),
      hintStyle: TextStyle(color: Color(defaultHighLightColor)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(defaultHighLightColor), width: 0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(defaultHighLightColor), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(defaultAntiColor), width: 2),
      ),
    ),
    cursorColor: Color(defaultAntiColor),
    style: TextStyle(color: Color(defaultAntiColor)),
    onChanged: onChanged,
  );
}


//保持页面
class KeepAliveWrapper extends StatefulWidget{
  const KeepAliveWrapper({
    Key? key,
    this.keepAlive = true,
    required this.child,
  }):super(key: key);
  final bool keepAlive;
  final Widget child;

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}
class _KeepAliveWrapperState extends State<KeepAliveWrapper> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context){
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget){
    if(oldWidget.keepAlive != widget.keepAlive){
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}


//允许监听多个ValueNotifier
class MultiValueListenableBuilder extends StatelessWidget {
  final List<ValueNotifier<dynamic>> listenables; // 明确限制为 ValueNotifier

  final Widget Function(BuildContext context, List<Object?> values) builder;

  final Widget? child;

  const MultiValueListenableBuilder({
    super.key,
    required this.listenables,
    required this.builder,
    this.child, // 添加 child 参数
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Object?>>(
      valueListenable: _CombinedValueListenable(listenables), // 使用改进后的内部类
      builder: (context, values, c) { // c 接收 ValueListenableBuilder 的 child
        return builder(context, values);
      },
      child: child, // 将外部传入的 child 传递给内部的 ValueListenableBuilder
    );
  }
}
class _CombinedValueListenable extends ValueNotifier<List<Object?>> {
  final List<ValueNotifier<dynamic>> _listenables; // 明确限制为 ValueNotifier
  final List<VoidCallback> _listenerCallbacks = []; // 存储回调函数

  _CombinedValueListenable(List<ValueNotifier<dynamic>> listenables)
      : _listenables = listenables,
        super([]) {
    final List<Object?> initialValues = List<Object?>.generate(listenables.length, (i) {
      return listenables[i].value; // 因为类型已限制，不再需要 if (listenable is ValueNotifier)
    });
    value = initialValues; // 设置初始值

    for (var i = 0; i < _listenables.length; i++) {
      final listenable = _listenables[i];
      // 因为 _listenables 已经被明确限制为 ValueNotifier<dynamic>，所以不再需要类型检查
      listenerCallback() {
        final currentValues = List<Object?>.from(value); // 获取当前组合值
        currentValues[i] = listenable.value; // 更新对应的值
        value = currentValues; // 触发更新
      }
      listenable.addListener(listenerCallback);
      _listenerCallbacks.add(listenerCallback);
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < _listenables.length; i++) {
      final listenable = _listenables[i];
      listenable.removeListener(_listenerCallbacks[i]);
    }
    super.dispose();
  }
}




class AutoResizeImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final BoxFit fit;
  final double width;
  final double height;

  AutoResizeImage({
    required this.imageProvider,
    this.fit = BoxFit.cover,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double actualWidth = constraints.maxWidth;
        final double actualHeight = constraints.maxHeight;

        return Image(
          image: ResizeImage(
            imageProvider,
            width: actualWidth.round(),
            height: actualHeight.round(),
          ),
          fit: fit,
          width: width,
          height: height,
        );
      },
    );
  }
}


//webview
abstract class webview{
  static OverlayEntry? overlay;
  static const defaultUrl = "https://myl.nuanpaper.com/home";

  static ValueNotifier<String> currentUrl = ValueNotifier<String>(defaultUrl);

  static late InAppWebViewController controller;

  //跳转至表情页面, 若不存在则创建
  static void url(String url){
    currentUrl.value = url;
    show();
  }

  static void forward(){
    controller.goForward();
  }

  static void back(){
    controller.goBack();
  }

  static void refresh(){
    controller.reload();
  }

  //显示webview
  static void show(){
    if(overlay != null){
      hide();
    }

    isWebview.value = true;

    overlay = OverlayEntry(
      builder: (context){
        return Stack(
          children: [
            //导航栏
            Positioned(
              left: sideBarWidth,
              top: 0,
              height: topBarHeight,
              child: Container(
                // color: Color(defaultWarningColor),
                child: Row(
                  children: [

                    //关闭按钮
                    IconButton(
                      icon: Image.asset("assets/icon/close.webp", height: 20),
                      onPressed: (){hide();},
                      style: buttonStyle(borderRadius: 8),
                    ),

                    //后退按钮
                    IconButton(
                      icon: Image.asset("assets/icon/back.webp", height: 20),
                      onPressed: (){back();},
                      style: buttonStyle(borderRadius: 8),
                    ),

                    //前进按钮
                    IconButton(
                      icon: Image.asset("assets/icon/forward.webp", height: 20),
                      onPressed: (){forward();},
                      style: buttonStyle(borderRadius: 8),
                    ),

                    //刷新按钮
                    IconButton(
                      icon: Image.asset("assets/icon/refresh.webp", height: 20),
                      onPressed: (){refresh();},
                      style: buttonStyle(borderRadius: 8),
                    ),
                  ],
                ),
              ),
            ),

            // //隐藏区
            // Positioned(
            //   left: 0,
            //   top: topBarHeight + 2,
            //   bottom: 0,
            //   width: sideBarWidth,
            //   child: GestureDetector(
            //     onTap: (){hide();},
            //   ),
            // ),

            //加载框
            Positioned(
              // left: sideBarWidth,
              left: 0,
              top: topBarHeight + 2,
              right: 0,
              bottom: 0,
              child: Container(
                color: Color(defaultMainColor),
                child: Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),

            //网页区
            Positioned(
              // left: sideBarWidth,
              left: 0,
              top: topBarHeight + 2,
              right: 0,
              bottom: 0,
              child: ValueListenableBuilder(
                valueListenable: currentUrl,
                builder: (context, value, tab){
                  return InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(currentUrl.value)),
                    onWebViewCreated: (controller){
                      controller = controller;
                    },
                  );
                },
              ),
            ),
          ],
        );
      }
    );

    Overlay.of(ancestor.currentContext!).insert(overlay!);

  }

  //隐藏webview
  static void hide(){

    isWebview.value = false;

    if(overlay != null){
      // controller.dispose();
      overlay?.remove();
      overlay = null;
    }
  }





}



//提示框
abstract class tip{
  static OverlayEntry? overlay;

  static Future show({
    String title = "",
    String message = "",
    String? url,
    String urlMessage = "",
    bool isChoose = false,
    String trueText = "知道了",
    String falseText = "拒绝",
    bool isForce = false,
  }){
    if(overlay != null){
      overlay?.remove();
      overlay = null;
    }

    final completer = Completer<bool>();

    overlay = OverlayEntry(
      builder: (context){
        return Stack(
          children: [

            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Color(0xAA000000),
                child: GestureDetector(
                  onTap: (){
                    if(!isForce){
                      if(!completer.isCompleted){
                        completer.complete(false);
                      }
                      overlay?.remove();
                      overlay = null;
                    }
                  },
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 300,
                  height: 500,
                  decoration: borderStyle(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Text(title, style: TextStyle(color: Color(defaultAntiColor), fontSize: 32, decoration: TextDecoration.none)),
                        block10H,
                        Text(message, style: TextStyle(color: Color(defaultAntiColor), fontSize: 16, decoration: TextDecoration.none)),
                        block10H,
                        if(url != null)
                          Container(
                            width: double.infinity,
                            height: 60,
                            child: TextButton(
                              onPressed: (){webview.url(url);},
                              style: buttonStyle(borderRadius: 16, color: defaultViceColor, colorOpacity: 1),
                              child: Text(urlMessage, style: TextStyle(color: Color(defaultAntiColor), fontSize: 16)),
                            ),
                          ),
                        block10H,
                        //true
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: TextButton(
                            onPressed: (){
                              if(!completer.isCompleted){
                                completer.complete(true);
                                overlay?.remove();
                                overlay = null;
                              }
                            },
                            style: buttonStyle(borderRadius: 16, color: defaultViceColor, colorOpacity: 0.5),
                            child: Text(trueText, style: TextStyle(color: Color(defaultAntiColor), fontSize: 16)),
                          ),
                        ),
                        block10H,
                        if(isChoose)
                          //false
                          Container(
                            width: double.infinity,
                            height: 60,
                            child: TextButton(
                              onPressed: (){
                                if(!completer.isCompleted){
                                  completer.complete(false);
                                  overlay?.remove();
                                  overlay = null;
                                }
                              },
                              style: buttonStyle(borderRadius: 16, color: defaultViceColor, colorOpacity: 0.5),
                              child: Text(falseText, style: TextStyle(color: Color(defaultAntiColor), fontSize: 16)),
                            ),
                          ),
                        block10H,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );

    Overlay.of(ancestor.currentContext!).insert(overlay!);

    return completer.future;
  }


}



// abstract class webview{
//   static OverlayEntry? overlay;
//   static const defaultUrl = "https://myl.nuanpaper.com/home";
//
//   static ValueNotifier<String> currentTab = ValueNotifier<String>("default");
//   static Map<String, GlobalKey> webviewKeyList = {};
//   static Map<String, InAppWebView> webviewList = {};
//   static Map<String, InAppWebViewController> webviewControllerList = {};
//
//   //跳转至表情页面, 若不存在则创建
//   static void tab(String tabName, {String? url}){
//     if(webviewKeyList.keys.contains(tabName)){
//       webviewControllerList[tabName];
//     }else{
//       final key = GlobalKey();
//       final widget = InAppWebView(
//         key: key,
//         initialUrlRequest: URLRequest(url: WebUri(url ?? defaultUrl)),
//         onWebViewCreated: (controller){
//           webviewControllerList[tabName] = controller;
//         },
//       );
//       webviewKeyList[tabName] = key;
//       webviewList[tabName] = widget;
//     }
//     currentTab.value = tabName;
//     show();
//   }
//
//   static void forward({String? tabName}){
//     webviewControllerList[tabName ?? currentTab.value]?.goForward();
//   }
//
//   static void back({String? tabName}){
//     webviewControllerList[tabName ?? currentTab.value]?.goBack();
//   }
//
//   static void refresh({String? tabName}){
//     webviewControllerList[tabName ?? currentTab.value]?.reload();
//   }
//
//   //关闭标签页
//   static void close(String tabName){
//
//   }
//
//   //显示webview
//   static void show(){
//     print("1");
//
//
//     if(overlay != null){
//       hide();
//     }
//
//     isWebview.value = true;
//
//     overlay = OverlayEntry(
//       builder: (context){
//         return Stack(
//           children: [
//             //导航栏
//             Positioned(
//               left: sideBarWidth,
//               top: 0,
//               height: topBarHeight,
//               child: Container(
//                 // color: Color(defaultWarningColor),
//                 child: Row(
//                   children: [
//
//                     //关闭按钮
//                     IconButton(
//                       icon: Image.asset("assets/icon/close.webp", height: 20),
//                       onPressed: (){hide();},
//                       style: buttonStyle(borderRadius: 8),
//                     ),
//
//                     //后退按钮
//                     IconButton(
//                       icon: Image.asset("assets/icon/back.webp", height: 20),
//                       onPressed: (){back();},
//                       style: buttonStyle(borderRadius: 8),
//                     ),
//
//                     //前进按钮
//                     IconButton(
//                       icon: Image.asset("assets/icon/forward.webp", height: 20),
//                       onPressed: (){forward();},
//                       style: buttonStyle(borderRadius: 8),
//                     ),
//
//                     //刷新按钮
//                     IconButton(
//                       icon: Image.asset("assets/icon/refresh.webp", height: 20),
//                       onPressed: (){refresh();},
//                       style: buttonStyle(borderRadius: 8),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             //隐藏区
//             Positioned(
//               left: 0,
//               top: topBarHeight + 2,
//               bottom: 0,
//               width: sideBarWidth,
//               child: GestureDetector(
//                 onTap: (){hide();},
//               ),
//             ),
//
//             //网页区
//             Positioned(
//               left: sideBarWidth,
//               top: topBarHeight + 2,
//               right: 0,
//               bottom: 0,
//               child: ValueListenableBuilder(
//                 valueListenable: currentTab,
//                 builder: (context, value, tab){
//                   return Container(
//                     child: webviewList[value],
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       }
//     );
//
//     Overlay.of(ancestor.currentContext!).insert(overlay!);
//
//   }
//
//   //隐藏webview
//   static void hide(){
//
//     isWebview.value = false;
//
//     if(overlay != null){
//       overlay?.remove();
//       overlay = null;
//     }
//   }
//
//
//
//
//
// }
