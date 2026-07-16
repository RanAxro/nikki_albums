import "dart:async";

import "package:nikki_albums/widgets/common/component.dart";

import "component.dart";

import "package:window_manager/window_manager.dart";
import "package:flutter/services.dart";

import "package:flutter/material.dart";
import "dart:io";

Future<T?> showAppDialog<T extends Object?>({
  required BuildContext context,
  bool isBarrier = false,
  Duration transitionDuration = animationTime,
  required Widget Function(BuildContext context) builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: transitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        onTap: () {
          if (isBarrier) {
            SystemSound.play(SystemSoundType.alert);
          } else {
            Navigator.pop(context);
          }
        },
        onPanStart: (_) async {
          if (Platform.isWindows) {
            await windowManager.startDragging();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(dialogSafePadding),
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              onPanStart: (_) {},
              child: Builder(builder: builder),
            ),
          ),
        ),
      );
    },
  );
}

class AppDialog extends StatelessWidget {
  final ColorRole colorRole;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final double? maxHeight;
  final BoxConstraints? constraints;
  final bool useIntrinsicWidth;
  final bool useIntrinsicHeight;
  final String? title;
  final bool isTranslate;
  final bool useCloseButton;
  final Widget child;

  const AppDialog({
    super.key,
    this.colorRole = ColorRole.background,
    this.borderRadius = dialogBorderRadius,
    this.padding = const EdgeInsets.all(smallPadding),
    this.maxWidth,
    this.maxHeight,
    this.constraints,
    this.useIntrinsicWidth = false,
    this.useIntrinsicHeight = true,
    this.title,
    this.isTranslate = true,
    this.useCloseButton = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;

    if (title != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: smallButtonSize,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: smallPadding),
                    child: AppText(
                      title!,
                      isTranslate: isTranslate,
                      fontSize: smallButtonContentSize,
                    ),
                  ),
                ),
                if (useCloseButton)
                  AppButton.smallIcon(
                    onClick: Navigator.of(context).pop,
                    child: AppIcon("cross", height: 20),
                  ),
              ],
            ),
          ),

          Expanded(child: child),
        ],
      );
    }

    child = ConstrainedBox(
      constraints:
          constraints ??
          BoxConstraints(
            maxWidth: maxWidth ?? double.infinity,
            maxHeight: maxHeight ?? double.infinity,
          ),
      child: Padding(padding: padding ?? const EdgeInsets.all(0), child: child),
    );

    if (useIntrinsicWidth) {
      child = IntrinsicWidth(child: child);
    }
    if (useIntrinsicHeight) {
      child = IntrinsicHeight(child: child);
    }

    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: AppBackground(colorRole: colorRole, child: child),
      ),
    );
  }
}

class AppConfirmDialog extends StatelessWidget{
  final ColorRole colorRole;
  final double? maxWidth;
  final double? maxHeight;
  final BoxConstraints? constraints;
  final bool useIntrinsicWidth;
  final bool useIntrinsicHeight;
  final String? title;
  final bool isTranslateTitle;
  final bool useCloseButton;
  final String message;
  final bool isTranslateMessage;
  final String yMessage;
  final bool isTranslateYMessage;
  final String nMessage;
  final bool isTranslateNMessage;
  final bool isRisk;

  const AppConfirmDialog({
    super.key,
    this.colorRole = ColorRole.background,
    this.maxWidth = smallCardMaxWidth,
    this.maxHeight,
    this.constraints,
    this.useIntrinsicWidth = false,
    this.useIntrinsicHeight = true,
    this.title,
    this.isTranslateTitle = true,
    this.useCloseButton = false,
    required this.message,
    this.isTranslateMessage = false,
    this.yMessage = "confirm",
    this.isTranslateYMessage = true,
    this.nMessage = "cancel",
    this.isTranslateNMessage = true,
    this.isRisk = false,
  });

  @override
  Widget build(BuildContext context){
    return AppDialog(
      colorRole: colorRole,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      constraints: constraints,
      useIntrinsicWidth: useIntrinsicWidth,
      useIntrinsicHeight: useIntrinsicHeight,
      title: title,
      isTranslate: isTranslateTitle,
      useCloseButton: useCloseButton,
      child: Column(
        spacing: listSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [

          block5H,

          SmoothPointerScroll(
            builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController) {
              return SingleChildScrollView(
                child: AppText(message, isTranslate: isTranslateMessage),
              );
            },
          ),

          block5H,

          Row(
            spacing: listSpacing,
            children: isRisk ?
              [
                Expanded(
                  child: AppButton.smallIcon(
                    width: null,
                    isTransparent: false,
                    onClick: (){
                      Navigator.of(context).pop(true);
                    },
                    child: AppText(yMessage, isTranslate: isTranslateYMessage),
                  ),
                ),
                Expanded(
                  child: AppButton.smallIcon(
                    width: null,
                    colorRole: ColorRole.highlight,
                    isTransparent: false,
                    onClick: (){
                      Navigator.of(context).pop(false);
                    },
                    child: AppText(nMessage, isTranslate: isTranslateNMessage),
                  ),
                ),
              ] :
              [
                Expanded(
                  child: AppButton.smallIcon(
                    width: null,
                    isTransparent: false,
                    onClick: (){
                      Navigator.of(context).pop(false);
                    },
                    child: AppText(nMessage, isTranslate: isTranslateNMessage),
                  ),
                ),
                Expanded(
                  child: AppButton.smallIcon(
                    width: null,
                    colorRole: ColorRole.highlight,
                    isTransparent: false,
                    onClick: (){
                      Navigator.of(context).pop(true);
                    },
                    child: AppText(yMessage, isTranslate: isTranslateYMessage),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}


class _AppToastModel{
  final BuildContext context;
  final dynamic id;
  final OverlayEntry overlayEntry;
  final Timer? timer;

  const _AppToastModel({
    required this.context,
    this.id,
    required this.overlayEntry,
    this.timer,
  });
}

abstract class AppToast{
  static final List<_AppToastModel> _toasts = [];

  static _AppToastModel? _getToast({dynamic id}){
    for(final _AppToastModel toast in _toasts){
      if(toast.id == id){
        return toast;
      }
    }

    return null;
  }

  static void _insertToast(_AppToastModel toast){
    _removeToast(id: toast.id);

    _toasts.add(toast);
    Overlay.of(toast.context).insert(toast.overlayEntry);
  }

  static void _removeToast({dynamic id}){
    final _AppToastModel? toast = _getToast(id: id);

    if(toast != null){
      toast.overlayEntry.remove();
      toast.timer?.cancel();
    }

    _toasts.remove(toast);
  }

  static OverlayEntry _buildOverlayEntry({
    required BuildContext context,
    ColorRole colorRole = ColorRole.background,
    double width = toastMaxWidth,
    double height = toastMaxHeight,
    bool state = true,
    String title = "ui_toast_tip",
    bool isTranslate = true,
    required Widget child,
    required void Function() onClose,
  }){
    return OverlayEntry(
      builder: (context){
        return Positioned(
          right: 20,
          bottom: 40,
          child: Material(
            color: AppThemeColor.transparent,
            child: AppThemeRole(
              colorRole: colorRole,
              child: FadeIn(
                offsetBegin: Offset(100, 0),
                child: Container(
                  padding: const EdgeInsets.only(left: topBarPadding, right: topBarPadding, bottom: topBarPadding),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(smallBorderRadius)),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.3],
                      colors: [
                        state ? AppThemeColor.littleGreen : AppThemeColor.littleRed,
                        AppColorScheme.of(context).byRole(ColorRole.of(context)).color,
                      ],
                    ),
                    boxShadow: [
                      const BoxShadow(
                        color: AppThemeColor.shadow,
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: topBarHeight,
                        child: Row(
                          children: [
                            SizedBox(width: smallPadding),
                            Expanded(
                              child: AppText(
                                title,
                                isTranslate: isTranslate,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppButton.smallIcon(
                              onClick: onClose,
                              child: AppIcon("cross"),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void show({
    required BuildContext context,
    dynamic id,
    Duration? duration = toastDuration,
    ColorRole colorRole = ColorRole.background,
    bool state = true,
    String title = "ui_toast_tip",
    bool isTranslate = true,
    required Widget child,
  }){
    final OverlayEntry overlayEntry = _buildOverlayEntry(
      context: context,
      colorRole: colorRole,
      state: state,
      title: title,
      isTranslate: isTranslate,
      child: child,
      onClose: (){
        hide(id: id);
      },
    );

    _insertToast(_AppToastModel(
      context: context,
      id: id,
      overlayEntry: overlayEntry,
      timer: duration == null ? null : Timer(duration, (){
        hide(id: id);
      }),
    ));
  }

  static void showMessage({
    required BuildContext context,
    dynamic id,
    Duration duration = toastDuration,
    ColorRole colorRole = ColorRole.background,
    bool state = true,
    String title = "ui_toast_tip",
    bool isTranslate = true,
    required String message,
  }){
    show(
      context: context,
      id: id,
      duration: duration,
      colorRole: colorRole,
      state: state,
      title: title,
      isTranslate: isTranslate,
      child: AppText(message, isTranslate: false),
    );
  }

  static void hide({dynamic id}){
    _removeToast(id: id);
  }
}


class AppTask{
  static final collection = AppTaskCollection();

  static List<AppTask> get tasks => collection.tasks;


  final Object id;
  final String? title;
  final String? message;
  final ValueNotifier<double?> progress;
  final void Function(double?)? onCancel;
  final bool _shouldAutoDispose;

  AppTask._({
    required this.id,
    this.title,
    this.message,
    required this.progress,
    this.onCancel,
    required bool shouldAutoDispose,
  }) : _shouldAutoDispose = shouldAutoDispose{
    progress.addListener(_listener);
  }

  factory AppTask.create({
    required Object id,
    String? title,
    String? message,
    ValueNotifier<double?>? progress,
    void Function(double?)? onCancel,
    void Function(AppTask)? onOldTask,
  }){
    final AppTask task = AppTask._(
      id: id,
      title: title,
      message: message,
      progress: progress ?? ValueNotifier<double?>(0),
      onCancel: onCancel,
      shouldAutoDispose: progress == null,
    );

    collection._addTask(task, onOldTask: onOldTask);

    return task;
  }

  void _listener(){
    if(progress.value == 1){
      dispose();
    }
  }

  bool _isDispose = false;

  bool get isDispose => _isDispose;

  void dispose(){
    if(_isDispose){
      return;
    }
    _isDispose = true;

    if(progress.value != null && progress.value != 1){
      onCancel?.call(progress.value);
    }
    if(_shouldAutoDispose){
      progress.dispose();
    }else{
      progress.removeListener(_listener);
    }

    collection._deleteTask(id);
  }
}

class AppTaskCollection extends ChangeNotifier{
  final List<AppTask> _tasks = [];

  AppTaskCollection();

  List<AppTask> get tasks => List.of(_tasks);

  AppTask? getTask(Object id){
    for(final AppTask task in _tasks){
      if(task.id == id){
        return task;
      }
    }
    return null;
  }

  void _addTask(AppTask task, {void Function(AppTask)? onOldTask}){
    final AppTask? oldTask = getTask(task.id);

    if(onOldTask != null && oldTask != null){
      onOldTask.call(oldTask);
    }else{
      oldTask?.dispose();
    }

    _tasks.add(task);

    notifyListeners();
  }

  void _deleteTask(Object id){
    final AppTask? oldTask = getTask(id);

    oldTask?.dispose();

    notifyListeners();
  }
}

abstract class AppTaskProgress{
  static final ValueNotifier<bool> _hasTask = ValueNotifier<bool>(false);
  static final List<AppTask> _tasks = [];

  static Future<void> show({
    required BuildContext context,
    required List<Object> id,
    bool lock = false,
  }) async{
    if(lock){

    }else{

    }
  }

  static AppTask? getTask(Object id){
    for(final AppTask task in _tasks){
      if(task.id == id){
        return task;
      }
    }

    return null;
  }

  static void addTask(AppTask task, {void Function(AppTask)? onOldTask}){
    final AppTask? oldTask = getTask(task.id);

    if(oldTask != null && onOldTask != null){
      onOldTask.call(oldTask);
    }else{
      deleteTask(task.id);
    }

    _tasks.add(task);
    _update();
  }

  static void deleteTask(Object id){
    final AppTask? task = getTask(id);

    task?.dispose();

    _tasks.remove(task);
    _update();
  }

  static void _update(){
    _tasks.removeWhere((AppTask task) => task.isDispose);

    _hasTask.value = _tasks.isNotEmpty;
  }
}


