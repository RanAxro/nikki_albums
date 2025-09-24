import "dart:async";

import "package:flutter/services.dart";
import "package:hotkey_manager/hotkey_manager.dart";
import "package:nikki_albums/state.dart";
import "package:nikki_albums/constants.dart";
import "package:nikki_albums/api/api.dart" as api;

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

  static InAppWebViewController? _controller;

  // Alt + space
  static final HotKey _hotKeySpace = HotKey(
    key: PhysicalKeyboardKey.space,
    modifiers: [
      HotKeyModifier.alt,
    ],
    scope: HotKeyScope.system, // 全局监听
  );
  // Alt + f11
  static final HotKey _hotKeyF11 = HotKey(
    key: PhysicalKeyboardKey.f11,
    modifiers: [
      HotKeyModifier.alt,
    ],
    scope: HotKeyScope.system,
  );
  // Alt + arrowLeft
  static final HotKey _hotKeyArrowLeft = HotKey(
    key: PhysicalKeyboardKey.arrowLeft,
    modifiers: [
      HotKeyModifier.alt,
    ],
    scope: HotKeyScope.system,
  );
  // Alt + arrowUp
  static final HotKey _hotKeyArrowUp = HotKey(
    key: PhysicalKeyboardKey.arrowUp,
    modifiers: [
      HotKeyModifier.alt,
    ],
    scope: HotKeyScope.system,
  );
  // Alt + arrowRight
  static final HotKey _hotKeyArrowRight = HotKey(
    key: PhysicalKeyboardKey.arrowRight,
    modifiers: [
      HotKeyModifier.alt,
    ],
    scope: HotKeyScope.system,
  );
  // Alt + arrowDown
  static final HotKey _hotKeyArrowDown = HotKey(
    key: PhysicalKeyboardKey.arrowDown,
    modifiers: [
      HotKeyModifier.alt,
    ],
    scope: HotKeyScope.system,
  );

  //跳转至表情页面, 若不存在则创建
  static void url(String url){
    currentUrl.value = url;
    show();
  }

  static void forward(){
    _controller?.goForward();
  }

  static void back(){
    _controller?.goBack();
  }

  static void refresh(){
    _controller?.reload();
  }

  //显示webview
  static void show(){
    if(overlay != null){
      hide();
    }

    isWebview.value = true;

    final (int width, int height) = api.getScreenSize();

    // webiview
    final webview = ValueListenableBuilder(
      valueListenable: currentUrl,
      builder: (context, value, tab){
        return InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(currentUrl.value)),
          onWebViewCreated: (controller){
            _controller = controller;
          },

          // 页面加载完成
          // onLoadStop: (controller, url) async{
          //
          //   // 复杂示例：注入一个函数: 每两秒隐藏bilibili video控制条
          //   await controller.evaluateJavascript(source: '''
          //     setInterval(() => {
          //       document.querySelectorAll(".bpx-player-pbp.show").forEach(e => {
          //         e.classList.remove("show");
          //       });
          //
          //       document.querySelectorAll(".bpx-player-pbp-pin").forEach(e => {
          //         e.style.opacity = "0";
          //       });
          //
          //       document.querySelectorAll(".bpx-player-container")
          //         .forEach(el => {
          //           el.setAttribute("data-ctrl-hidden", "true");
          //           el.classList.add("bpx-state-no-cursor");
          //         });
          //
          //       document.querySelectorAll('.bpx-player-control-entity')
          //         .forEach(el => el.setAttribute('data-shadow-show', 'true'));
          //     }, 2000);
          //   ''');
          // },

        );
      },
    );

    // hot key
    // 暂停/播放视频
    hotKeyManager.register(
      _hotKeySpace,
      keyDownHandler: (_){
        _controller!.evaluateJavascript(source: '''
          document.querySelectorAll("video").forEach(
            v => v.paused ? v.play() : v.pause()
          );
        ''');
      },
    );
    hotKeyManager.register(
      _hotKeyF11,
      keyDownHandler: (_){
        _controller!.evaluateJavascript(source: '''
          document.querySelectorAll("video").forEach(
            function(v){
              if(v){
                const inFs = !!(document.fullscreenElement ||
                  document.webkitFullscreenElement ||
                  document.msFullscreenElement);
                if(inFs){
                  const exit = document.exitFullscreen ||
                     document.webkitExitFullscreen ||
                     document.msExitFullscreen;
                  exit.call(document);
                }else{
                  const enter = v.requestFullscreen ||
                    v.webkitRequestFullscreen ||
                    v.msRequestFullscreen;
                  enter.call(v);
                }
              }
            }
          );
        ''');
      },
    );
    // 视频后退5s
    hotKeyManager.register(
      _hotKeyArrowLeft,
      keyDownHandler: (_){
        _controller!.evaluateJavascript(source: '''
          document.querySelectorAll("video").forEach(v => v.currentTime -= 5);
        ''');
      },
    );
    // 视频前进5s
    hotKeyManager.register(
      _hotKeyArrowRight,
      keyDownHandler: (_){
        _controller!.evaluateJavascript(source: '''
          document.querySelectorAll("video").forEach(v => v.currentTime += 5);
        ''');
      },
    );
    // 视频音量增加10%
    hotKeyManager.register(
      _hotKeyArrowUp,
      keyDownHandler: (_){
        _controller!.evaluateJavascript(source: '''
          document.querySelectorAll("video").forEach(v => v && (v.volume = Math.min(1, v.volume + 0.1)));
        ''');
      },
    );
    // 视频音量减少10%
    hotKeyManager.register(
      _hotKeyArrowDown,
      keyDownHandler: (_){
        _controller!.evaluateJavascript(source: '''
          document.querySelectorAll("video").forEach(v => v && (v.volume = Math.max(0, v.volume - 0.1)));
        ''');
      },
    );

    // overlay
    overlay = OverlayEntry(
      builder: (context){
        return Stack(
          children: [
            //导航栏
            Positioned(
              left: sideBarWidth,
              top: 0,
              right: 0,
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

                    //链接复制按钮
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          //TODO 点击复制
                          onPressed: () async{await Clipboard.setData(ClipboardData(text: currentUrl.value));},
                          style: buttonStyle(borderRadius: 8, minHeight: topBarHeight - 5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(currentUrl.value, overflow: TextOverflow.ellipsis, style: TextStyle(color: Color(defaultAntiColor))),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: topBarHeight * 3 + 120,
                    )

                  ],
                ),
              ),
            ),

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
              child: LayoutBuilder(
                builder: (context, c){
                  final ratio = c.maxWidth / (c.maxHeight == 0 ? 1 : c.maxHeight);
                  final fixedWidth = 0.5 * width.toDouble();
                  final height = fixedWidth / ratio;
                  return FittedBox(
                    child: SizedBox(
                      width: fixedWidth,
                      height: height,
                      child: webview,
                    ),
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
      _controller?.dispose();
      _controller = null;

      hotKeyManager.unregister(_hotKeySpace);
      hotKeyManager.unregister(_hotKeyF11);
      hotKeyManager.unregister(_hotKeyArrowLeft);
      hotKeyManager.unregister(_hotKeyArrowUp);
      hotKeyManager.unregister(_hotKeyArrowRight);
      hotKeyManager.unregister(_hotKeyArrowDown);

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
    bool isWarning = false,
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
                        Text(title, style: TextStyle(color: Color(isWarning ? defaultWarningColor : defaultAntiColor), fontSize: 32, decoration: TextDecoration.none)),
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



//alert
abstract class alert{
  static OverlayEntry? overlay;

  static Future show({
    String text = "",
    String trueText = "是",
    String falseText = "否",
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
              child: GestureDetector(
                onTap: (){
                  completer.complete(false);
                  overlay?.remove();
                  overlay = null;
                },
                onSecondaryTap: (){
                  completer.complete(false);
                  overlay?.remove();
                  overlay = null;
                },
                child: const ColoredBox(color: Color(0xAA000000)),
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
                  width: 400,
                  height: 200,
                  decoration: borderStyle(),
                  child: Column(
                    children: [
                      Expanded(
                        child: Material(
                          color: Color(0x00000000),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(text, style: TextStyle(color: Color(defaultAntiColor), fontSize: 24),),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // true
                          Expanded(
                            child: TextButton(
                              onPressed: (){
                                if(!completer.isCompleted){
                                  completer.complete(true);
                                  overlay?.remove();
                                  overlay = null;
                                }
                              },
                              style: buttonStyle(borderRadius: 8, minHeight: topBarHeight, color: defaultViceColor, colorOpacity: 0.5),
                              child: Text(trueText, style: TextStyle(color: Color(defaultAntiColor), fontSize: 16)),
                            ),
                          ),
                          block5W,
                          // false
                          Expanded(
                            child: TextButton(
                              onPressed: (){
                                if(!completer.isCompleted){
                                  completer.complete(false);
                                  overlay?.remove();
                                  overlay = null;
                                }
                              },
                              style: buttonStyle(borderRadius: 8, minHeight: topBarHeight, color: defaultViceColor, colorOpacity: 0.5),
                              child: Text(falseText, style: TextStyle(color: Color(defaultAntiColor), fontSize: 16)),
                            ),
                          ),
                        ],
                      )
                    ],
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