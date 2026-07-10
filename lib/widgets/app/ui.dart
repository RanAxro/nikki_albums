
import "package:nikki_albums/widgets/common/component.dart";
import "component.dart";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:easy_localization/easy_localization.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:super_tooltip/super_tooltip.dart";


class AppDivider extends StatelessWidget {
  final Axis direction;
  final double margin;
  final double thickness;

  const AppDivider({
    super.key,
    this.direction = Axis.horizontal,
    this.margin = 1,
    this.thickness = smallDividerThickness,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? VerticalDivider(
            width: thickness + margin * 2,
            thickness: thickness,
            indent: smallPadding,
            endIndent: smallPadding,
            color: AppColorScheme.of(
              context,
            ).byRole(ColorRole.of(context)).onDisabledColor,
          )
        : Divider(
            height: thickness + margin * 2,
            thickness: thickness,
            indent: smallPadding,
            endIndent: smallPadding,
            color: AppColorScheme.of(
              context,
            ).byRole(ColorRole.of(context)).onDisabledColor,
          );
  }
}

class RFutureBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(BuildContext context, Widget indicator)? waitingBuilder;
  final Widget Function(BuildContext context)? errorBuilder;
  final Widget Function(BuildContext, T) builder;

  const RFutureBuilder({
    super.key,
    required this.future,
    this.waitingBuilder,
    this.errorBuilder,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          final Widget indicator = Padding(
            padding: const EdgeInsets.all(smallPadding),
            child: CircularProgressIndicator(
              backgroundColor: AppTheme.of(context)!.colorScheme.primary.color,
              color: AppTheme.of(context)!.colorScheme.primary.onColor,
              constraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
            ),
          );
          if (waitingBuilder != null) {
            return waitingBuilder!(context, indicator);
          }
          return indicator;
        }
        if (snapshot.hasError) {
          if (errorBuilder != null) errorBuilder!(context);
          return block0;
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}

Future<T?> showProgressBar<T>({
  required BuildContext context,
  required ValueNotifier<double?> valueListenable,
  String? title,
  bool barrierDismissible = false,
  bool autoClose = true,
  Widget Function(BuildContext context)? builder,
  Widget Function(BuildContext context, void Function([T? value]) close)?
  completedBuilder,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      final Widget? buildChild = builder?.call(context);

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
        ),
        backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
        child: Container(
          padding: const EdgeInsets.all(bigPadding),
          constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
          child: ValueListenableBuilder<double?>(
            valueListenable: valueListenable,
            builder: (BuildContext context, double? progress, Widget? child) {
              String text = title ?? "";
              if (progress != null) {
                if (progress >= 1) {
                  text += " ( ${context.tr("completed")} )";
                } else {
                  text += " ( ${(progress * 100).toInt()} % )";
                }
              }

              if ((!barrierDismissible && completedBuilder == null) ||
                  autoClose) {
                if (progress != null && progress >= 1) {
                  Navigator.of(context).pop();
                }
              }

              return Column(
                spacing: bigListSpacing,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.of(
                      context,
                    )!.colorScheme.primary.color,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.of(context)!.colorScheme.primary.onColor,
                    ),
                    minHeight: 4,
                  ),
                  ?buildChild,
                  if (progress != null && progress >= 1)
                    ?completedBuilder?.call(
                      context,
                      ([T? value]) => Navigator.of(context).pop(value),
                    ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

class AppBackground extends StatelessWidget {
  final ColorRole? colorRole;
  final bool isPass;
  final Widget? child;

  const AppBackground({
    super.key,
    this.colorRole,
    this.isPass = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ColorRole currentColorRole = colorRole ?? ColorRole.of(context);

    return ColoredBox(
      color: AppColorScheme.of(context).byRole(currentColorRole).color,
      child: isPass && child != null ? AppThemeRole(child: child!) : child,
    );
  }
}

class AppButtonStyle {
  final double? width;
  final double? height;
  final double? borderRadius;
  final (ColorRole colorRole, ColorState colorState, bool isTransparent)
  Function(bool usable, bool isSelected, bool isInside, bool isPressed)?
  shader;

  const AppButtonStyle({
    this.width,
    this.height,
    this.borderRadius,
    this.shader,
  });
}

class AppButtonConfiguration extends InheritedWidget {
  final AppButtonStyle style;

  const AppButtonConfiguration({
    super.key,
    required this.style,
    required super.child,
  });

  @override
  bool updateShouldNotify(AppButtonConfiguration oldWidget) {
    return oldWidget.style != style;
  }

  static AppButtonConfiguration? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppButtonConfiguration>();
  }
}

class AppRawButton extends StatefulWidget {
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final (ColorRole colorRole, ColorState colorState, bool isTransparent)
  Function(bool usable, bool isSelected, bool isInside, bool isPressed)?
  shader;
  final bool useConfiguration;

  final String? toolTip;
  final bool isTranslate;
  final List<LogicalKeyboardKey>? toolTipShortcut;
  final bool usable;
  final bool isSelected;
  final void Function()? onClick;
  final Widget? child;
  final Widget? Function(
    BuildContext context,
    Widget? child,
    bool isHovered,
    bool isPressed,
  )?
  builder;

  const AppRawButton({
    super.key,
    this.duration = animationTime,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.padding,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.borderRadius,
    this.shader,
    this.useConfiguration = true,
    this.toolTip,
    this.isTranslate = true,
    this.toolTipShortcut,
    this.usable = true,
    this.isSelected = false,
    this.onClick,
    this.child,
    this.builder,
  });

  @override
  State<AppRawButton> createState() => _AppRawButtonState();
}

class _AppRawButtonState extends State<AppRawButton> {
  bool isInside = false;
  bool isPressed = false;

  void onMouseEnter() {
    isInside = true;
  }

  void onMouseExit() {
    isInside = false;
    isPressed = false;
  }

  void onPointerDown(int pressedButton) {
    if (pressedButton == kPrimaryMouseButton) {
      isPressed = true;
    }
  }

  void onPointerUp() {
    isPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final AppButtonStyle? style = widget.useConfiguration
        ? AppButtonConfiguration.of(context)?.style
        : null;

    final (colorRole, colorState, isTransparent) =
        style?.shader?.call(widget.usable, widget.isSelected, isInside, isPressed) ??
        widget.shader?.call(widget.usable, widget.isSelected, isInside, isPressed) ??
        (ColorRole.of(context), ColorState.normal, true);

    final Widget? child =
        widget.builder?.call(context, widget.child, isInside, isPressed) ??
        widget.child;

    Widget button = AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      alignment: widget.alignment,
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(style?.borderRadius ?? widget.borderRadius ?? 0),
        ),
        color: isTransparent
            ? AppColorScheme.of(
                context,
              ).byRole(colorRole).byState(colorState).withAlpha(0)
            : AppColorScheme.of(context).byRole(colorRole).byState(colorState),
      ),
      width: style?.width ?? widget.width,
      height: style?.height ?? widget.height,
      constraints: widget.constraints,
      margin: widget.margin,
      child: child == null
          ? null
          : AppThemeRole(
              colorRole: colorRole,
              child: AppThemeState(colorState: colorState, child: child),
            ),
    );

    if (widget.toolTip != null && widget.usable) {
      String? message = widget.isTranslate
          ? context.tr(widget.toolTip.toString())
          : widget.toolTip;
      if (widget.toolTipShortcut != null) {
        message =
            "${message ?? ""} ${getKeyboardCharacter(widget.toolTipShortcut!)}";
      }

      button = Tooltip(message: message, child: button);
    }

    return GestureDetector(
      onTap: widget.usable ? widget.onClick : null,
      child: MouseRegion(
        cursor: widget.usable
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (PointerEnterEvent event) {
          setState(() {
            onMouseEnter();
          });
        },
        onExit: (PointerExitEvent event) {
          setState(() {
            onMouseExit();
          });
        },
        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            setState(() {
              onPointerDown(event.buttons);
            });
          },
          onPointerUp: (PointerUpEvent event) {
            setState(() {
              onPointerUp();
            });
          },
          onPointerCancel: (PointerCancelEvent event) {
            setState(() {
              onPointerUp();
            });
          },
          child: button,
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final ColorRole? colorRole;
  final bool isTransparent;
  final bool useConfiguration;

  final String? toolTip;
  final bool isTranslate;
  final List<LogicalKeyboardKey>? toolTipShortcut;
  final bool usable;
  final void Function()? onClick;
  final Widget? child;
  final Widget? Function(
    BuildContext context,
    Widget? child,
    bool isHovered,
    bool isPressed,
  )?
  builder;

  const AppButton({
    super.key,
    this.duration = animationTime,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.padding,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.borderRadius,
    this.colorRole,
    this.isTransparent = true,
    this.useConfiguration = true,
    this.toolTip,
    this.toolTipShortcut,
    this.isTranslate = true,
    this.usable = true,
    this.onClick,
    this.child,
    this.builder,
  });

  (ColorRole colorRole, ColorState colorState, bool isTransparent) shader(
    BuildContext context,
    bool usable,
    bool isInside,
    bool isPressed,
  ) {
    ColorRole colorRole = this.colorRole ?? ColorRole.of(context);
    ColorState colorState = ColorState.normal;
    bool isTransparent = usable
        ? this.isTransparent && !isInside && !isPressed
        : this.isTransparent;

    if (usable) {
      colorState = ColorState.enabled;

      if (isInside) {
        colorState = ColorState.hovered;
      }
      if (isPressed) {
        colorState = ColorState.pressed;
      }
    } else {
      colorState = ColorState.disabled;
    }

    return (colorRole, colorState, isTransparent);
  }

  @override
  Widget build(BuildContext context) {
    return AppRawButton(
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      borderRadius: borderRadius,
      shader: (bool usable, bool isSelected, bool isInside, bool isPressed) {
        return shader(context, usable, isInside, isPressed);
      },
      useConfiguration: useConfiguration,
      toolTip: toolTip,
      isTranslate: isTranslate,
      toolTipShortcut: toolTipShortcut,
      usable: usable,
      onClick: onClick,
      builder: builder,
      child: child,
    );
  }

  factory AppButton.smallIcon({
    Key? key,
    Duration duration = animationTime,
    Curve curve = Curves.linear,
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry? padding,
    double? width = smallButtonSize,
    double? height = smallButtonSize,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    double borderRadius = smallBorderRadius,
    ColorRole? colorRole,
    bool isTransparent = true,
    bool useConfiguration = true,
    String? toolTip,
    bool isTranslate = true,
    List<LogicalKeyboardKey>? toolTipShortcut,
    bool usable = true,
    void Function()? onClick,
    Widget? child,
    Widget? Function(BuildContext, Widget?, bool, bool)? builder,
  }) {
    return AppButton(
      key: key,
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      borderRadius: borderRadius,
      colorRole: colorRole,
      isTransparent: isTransparent,
      useConfiguration: useConfiguration,
      toolTip: toolTip,
      isTranslate: isTranslate,
      toolTipShortcut: toolTipShortcut,
      usable: usable,
      onClick: onClick,
      builder: builder,
      child: child,
    );
  }

  factory AppButton.smallText({
    Key? key,
    Duration duration = animationTime,
    Curve curve = Curves.linear,
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(
      horizontal: smallPadding,
    ),
    double? width,
    double? height = smallButtonSize,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    double borderRadius = smallBorderRadius,
    ColorRole? colorRole,
    bool isTransparent = true,
    bool useConfiguration = true,
    String? toolTip,
    bool isTranslate = true,
    List<LogicalKeyboardKey>? toolTipShortcut,
    bool usable = true,
    void Function()? onClick,
    Widget? child,
    Widget? Function(BuildContext, Widget?, bool, bool)? builder,
  }) {
    return AppButton(
      key: key,
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      borderRadius: borderRadius,
      colorRole: colorRole,
      isTransparent: isTransparent,
      useConfiguration: useConfiguration,
      toolTip: toolTip,
      isTranslate: isTranslate,
      toolTipShortcut: toolTipShortcut,
      usable: usable,
      onClick: onClick,
      builder: builder,
      child: child,
    );
  }
}

class AppFloatingIndicatorButtonGroup extends StatelessWidget{
  final Duration floatDuration;
  final Duration delta;
  final bool hideWhenNoTarget;
  final double borderRadius;
  final Widget child;

  const AppFloatingIndicatorButtonGroup({
    super.key,
    this.floatDuration = const Duration(milliseconds: 100),
    this.delta = const Duration(milliseconds: 150),
    this.hideWhenNoTarget = true,
    this.borderRadius = smallBorderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return FloatingIndicatorGroup(
      floatDuration: floatDuration,
      delta: delta,
      hideWhenNoTarget: hideWhenNoTarget,
      putBottom: true,
      indicatorBuilder: (BuildContext context, BoxConstraints constraints, [Object? info]){
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: AppColorScheme.of(context).byRole(ColorRole.of(context)).hoveredColor,
          ),
        );
      },
      child: child,
    );
  }
}

class AppFloatingIndicatorButtonTarget extends StatelessWidget{
  final bool isTarget;
  final bool defaultTarget;
  final Object? info;
  final Widget child;

  const AppFloatingIndicatorButtonTarget({
    super.key,
    this.isTarget = true,
    this.defaultTarget = false,
    this.info,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    if(!isTarget){
      return child;
    }

    return AppButtonConfiguration(
      style: AppButtonStyle(
        shader: (bool usable, bool isSelected, bool isInside, bool isPressed){
          ColorRole colorRole = ColorRole.of(context);
          ColorState colorState = ColorState.normal;
          bool isTransparent = true;

          if(usable){
            colorState = ColorState.enabled;
            if(isSelected){
              colorState = ColorState.pressed;
              isTransparent = false;
            }
            if(isInside){
              colorState = ColorState.hovered;
            }
            if(isPressed){
              colorState = ColorState.pressed;
              isTransparent = false;
            }
          }else{
            colorState = ColorState.disabled;
          }

          return (colorRole, colorState, isTransparent);
        },
      ),
      child: FloatingIndicatorTarget(
        defaultTarget: defaultTarget,
        info: info,
        child: child,
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final ColorRole? colorRole;
  final bool isTransparent;

  final bool value;
  final String? toolTip;
  final bool isTranslate;
  final bool usable;
  final void Function(bool newValue)? onChanged;
  final Widget? child;
  final Widget? Function(
    BuildContext context,
    Widget? child,
    bool isHovered,
    bool isPressed,
  )?
  builder;

  const AppSwitch({
    super.key,
    this.duration = animationTime,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.padding,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.borderRadius,
    this.colorRole,
    this.isTransparent = true,
    this.value = false,
    this.toolTip,
    this.isTranslate = true,
    this.usable = true,
    this.onChanged,
    this.child,
    this.builder,
  });

  factory AppSwitch.smallIcon({
    Duration duration = animationTime,
    Curve curve = Curves.linear,
    AlignmentGeometry alignment = Alignment.center,
    EdgeInsetsGeometry? padding,
    double? width = smallButtonSize,
    double? height = smallButtonSize,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    double? borderRadius = smallBorderRadius,
    ColorRole? colorRole,
    bool isTransparent = true,
    bool value = false,
    String? toolTip,
    bool isTranslate = true,
    bool usable = true,
    void Function(bool newValue)? onChanged,
    Widget? child,
    Widget? Function(
      BuildContext context,
      Widget? child,
      bool isHovered,
      bool isPressed,
    )?
    builder,
  }) {
    return AppSwitch(
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      borderRadius: borderRadius,
      colorRole: colorRole,
      isTransparent: isTransparent,
      value: value,
      toolTip: toolTip,
      isTranslate: isTranslate,
      usable: usable,
      onChanged: onChanged,
      builder: builder,
      child: child,
    );
  }

  factory AppSwitch.smallText({
    Duration duration = animationTime,
    Curve curve = Curves.linear,
    AlignmentGeometry alignment = Alignment.center,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(
      horizontal: smallPadding,
    ),
    double? width,
    double? height = smallButtonSize,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    double? borderRadius = smallBorderRadius,
    ColorRole? colorRole,
    bool isTransparent = true,
    bool value = false,
    String? toolTip,
    bool isTranslate = true,
    bool usable = true,
    void Function(bool newValue)? onChanged,
    Widget? child,
    Widget? Function(
      BuildContext context,
      Widget? child,
      bool isHovered,
      bool isPressed,
    )?
    builder,
  }) {
    return AppSwitch(
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      borderRadius: borderRadius,
      colorRole: colorRole,
      isTransparent: isTransparent,
      value: value,
      toolTip: toolTip,
      isTranslate: isTranslate,
      usable: usable,
      onChanged: onChanged,
      builder: builder,
      child: child,
    );
  }

  (ColorRole colorRole, ColorState colorState, bool isTransparent) shader(
    BuildContext context,
    bool usable,
    bool isSelected,
    bool isInside,
    bool isPressed,
  ) {
    ColorRole colorRole = this.colorRole ?? ColorRole.of(context);
    ColorState colorState = ColorState.normal;
    bool isTransparent = usable
        ? this.isTransparent && !isInside && !isPressed
        : this.isTransparent;

    if (usable) {
      if (isSelected) {
        colorState = ColorState.pressed;
        isTransparent = false;

        if (isInside) {
          colorState = ColorState.pressed;
        }
        if (isPressed) {
          colorState = ColorState.hovered;
        }
      } else {
        colorState = ColorState.enabled;

        if (isInside) {
          colorState = ColorState.hovered;
        }
        if (isPressed) {
          colorState = ColorState.pressed;
        }
      }
    } else {
      colorState = isSelected ? ColorState.hovered : ColorState.disabled;
    }

    return (colorRole, colorState, isTransparent);
  }

  @override
  Widget build(BuildContext context) {
    return AppRawButton(
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      borderRadius: borderRadius,
      shader: (bool usable, bool isSelected, bool isInside, bool isPressed) {
        return shader(context, usable, isSelected, isInside, isPressed);
      },
      toolTip: toolTip,
      usable: usable,
      isSelected: value,
      onClick: () {
        onChanged?.call(!value);
      },
      builder: builder,
      child: child,
    );
  }
}

class AppUncontrolledSwitch extends StatefulWidget {
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final ColorRole? colorRole;
  final bool isTransparent;

  final bool initValue;
  final void Function(bool value)? onChanged;
  final String? toolTip;
  final bool isTranslate;
  final bool usable;
  final Widget? child;
  final Widget? Function(
    BuildContext context,
    Widget? child,
    bool isHovered,
    bool isPressed,
  )?
  builder;

  const AppUncontrolledSwitch({
    super.key,
    this.duration = animationTime,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.padding,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.borderRadius = smallBorderRadius,
    this.colorRole,
    this.isTransparent = true,
    this.initValue = false,
    this.onChanged,
    this.toolTip,
    this.isTranslate = true,
    this.usable = true,
    this.child,
    this.builder,
  });

  @override
  State<AppUncontrolledSwitch> createState() => _AppUncontrolledSwitchState();
}

class _AppUncontrolledSwitchState extends State<AppUncontrolledSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppSwitch(
      duration: widget.duration,
      curve: widget.curve,
      alignment: widget.alignment,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      margin: widget.margin,
      borderRadius: widget.borderRadius,
      colorRole: widget.colorRole,
      isTransparent: widget.isTransparent,
      value: value,
      toolTip: widget.toolTip,
      isTranslate: widget.isTranslate,
      usable: widget.usable,
      onChanged: (bool _) {
        setState(() {
          value = !value;
          widget.onChanged?.call(value);
        });
      },
      builder: widget.builder,
      child: widget.child,
    );
  }
}

class AppRadioStack extends StatefulWidget{
  final Duration duration;
  final Axis direction;
  final double spacing;
  final int selectedIndex;
  final List<Widget> children;

  const AppRadioStack({
    super.key,
    this.duration = animationTime,
    this.direction = Axis.horizontal,
    this.spacing = 0.0,
    this.selectedIndex = 0,
    required this.children,
  });

  @override
  State<AppRadioStack> createState() => _AppRadioStackState();
}

class _AppRadioStackState extends State<AppRadioStack>{
  Offset _offset = Offset.zero;
  final ValueNotifier<Rect> indicator = ValueNotifier(Rect.zero);

  Rect? _getRect(BuildContext context){
    final RenderObject? renderObject = context.findRenderObject();
    if(renderObject == null) return null;

    if(renderObject is RenderBox && renderObject.hasSize){
      final Offset offset = renderObject.localToGlobal(Offset.zero);
      final Size size = renderObject.size;
      return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    }

    return null;
  }

  Offset get offset => _offset;

  set offset(Offset newOffset){
    if(newOffset != _offset){
      setState((){
        _offset = newOffset;
      });
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      offset = _getRect(context)?.topLeft ?? Offset.zero;
    });

    final List<Widget> children = <Widget>[];
    for(int index = 0; index < widget.children.length; index++){
      children.add(
        RenderListener(
          onRender: (Rect rect){
            if(index == widget.selectedIndex){
              indicator.value = rect.shift(-offset);
            }
          },
          child: AppFloatingIndicatorButtonTarget(
            defaultTarget: index == widget.selectedIndex,
            child: widget.children[index],
          ),
        ),
      );
    }

    return Stack(
      children: [
        AppFloatingIndicatorButtonGroup(
          hideWhenNoTarget: false,
          child: widget.direction == Axis.horizontal ?
            Row(spacing: widget.spacing, children: children) :
            Column(spacing: widget.spacing, children: children),
        ),

        /// Indicator
        ValueListenableBuilder(
          valueListenable: indicator,
          builder: (BuildContext context, Rect rect, Widget? child){
            return AnimatedPositioned(
              duration: widget.duration,
              left: widget.direction == Axis.vertical ? rect.left + 1 : rect.left,
              top: widget.direction == Axis.horizontal ? rect.top - 1 : rect.top,
              width: rect.width,
              height: rect.height,
              child: Align(
                alignment: widget.direction == Axis.vertical ? Alignment.centerLeft : Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: widget.duration,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    color: AppColorScheme.of(context).byRole(ColorRole.of(context)).onHoveredColor
                  ),
                  width: widget.direction == Axis.vertical ? 2 : 0.5 * rect.width,
                  height: widget.direction == Axis.horizontal ? 2 : 0.5 * rect.height,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}

class AppNavBuilder<T> extends StatefulWidget {
  final T initValue;
  final void Function(T value)? onChanged;
  final Widget Function(
    BuildContext context,
    T value,
    void Function(T newValue) change,
  )
  builder;

  const AppNavBuilder({
    super.key,
    required this.initValue,
    this.onChanged,
    required this.builder,
  });

  @override
  State<AppNavBuilder<T>> createState() => _AppNavBuilderState<T>();
}

class _AppNavBuilderState<T> extends State<AppNavBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.initValue;
  }

  void change(T newValue) {
    if (value == newValue) return;

    setState(() {
      value = newValue;
      widget.onChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, change);
  }
}

class AppText extends StatelessWidget {
  final String data;
  final bool isTranslate;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final bool? softWrap;

  const AppText(
    this.data, {
    super.key,
    this.isTranslate = false,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.softWrap,
  });

  factory AppText.tr(
    String data, {
    Key? key,
    double? fontSize,
    FontWeight? fontWeight,
    TextOverflow? overflow,
    bool? softWrap,
  }){
    return AppText(
      data,
      key: key,
      isTranslate: true,
      fontSize: fontSize,
      fontWeight: fontWeight,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      isTranslate ? context.tr(data) : data,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColorScheme.of(
          context,
        ).byRole(ColorRole.of(context)).onByState(ColorState.of(context)),
        // color: AppTheme.of(context).colorScheme.byRole(AppThemeRole.of(context).colorRole).onByState(AppThemeState.of(context).colorState),
      ),
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

class AppIcon extends StatelessWidget {
  final String name;
  final bool isDye;
  final double? opacity;
  final double? scale;
  final double? width;
  final double? height;

  const AppIcon(
    this.name, {
    super.key,
    this.isDye = true,
    this.opacity,
    this.scale,
    this.width,
    this.height = smallButtonContentSize,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = AppColorScheme.of(
      context,
    ).byRole(ColorRole.of(context)).onByState(ColorState.of(context));

    return Image.asset(
      "assets/icon/$name.webp",
      scale: scale,
      width: width,
      height: height,
      color: isDye
          ? opacity == null
                ? color
                : color.withAlpha((opacity! * 255).toInt())
          : null,
    );
  }
}

class AppTextFiled extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool isTranslateLabel;
  final String? hintText;
  final bool isTranslateHint;
  final void Function(String)? onChanged;

  const AppTextFiled({
    super.key,
    this.controller,
    this.labelText,
    this.isTranslateLabel = true,
    this.hintText,
    this.isTranslateHint = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: AppColorScheme.of(
        context,
      ).byRole(ColorRole.of(context)).onColor,
      style: TextStyle(
        color: AppColorScheme.of(context).byRole(ColorRole.of(context)).onColor,
      ),
      decoration: InputDecoration(
        labelText: isTranslateLabel && labelText != null
            ? context.tr(labelText!)
            : labelText,
        hintText: isTranslateHint && hintText != null
            ? context.tr(hintText!)
            : hintText,
        labelStyle: TextStyle(
          color: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onColor,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onPressedColor,
        ),
        hintStyle: TextStyle(
          color: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onColor,
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColorScheme.of(
          context,
        ).byRole(ColorRole.of(context)).enabledColor,
      ),
    );
  }
}

class AppKVText extends StatelessWidget {
  final String? k;
  final bool isTranslateKey;
  final String? v;
  final bool isTranslateValue;

  const AppKVText({
    super.key,
    this.k,
    this.isTranslateKey = true,
    this.v,
    this.isTranslateValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(smallBorderRadius),
        ),
        border: Border.all(
          color: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onColor,
          width: tinyBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(smallBorderRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: smallPadding,
                vertical: tinyPadding,
              ),
              color: AppColorScheme.of(context).primary.hoveredColor,
              child: k == null
                  ? null
                  : AppText(k!, isTranslate: isTranslateKey),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: smallPadding,
                vertical: tinyPadding,
              ),
              color: AppColorScheme.of(context).background.color,
              child: v == null
                  ? null
                  : AppText(v!, isTranslate: isTranslateValue),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;

  final SliderInteraction? allowedInteraction;
  final void Function(double)? onChanged;
  final void Function(double)? onChangeStart;
  final void Function(double)? onChangeEnd;
  final String Function(double)? semanticFormatterCallback;

  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  const AppSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,

    this.allowedInteraction,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticFormatterCallback,

    this.padding = const EdgeInsets.symmetric(vertical: bigPadding),
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          /// 比例 [0, 1]
          final double ratio = (value - min) / (max - min);

          /// track左边部分的长度
          final double activeTrackLength = constraints.maxWidth * ratio;

          /// 圆球距离左边的长度
          /// left \in [0, w-2s]. (w 为 constraints.maxWidth, s 为 sliderThickness)
          /// left = r(left_max - left_min) = rw-2rs = a-2rs
          final double thumbLeft =
              activeTrackLength - 2 * ratio * sliderThickness;

          late final Widget track;
          if (gradient == null) {
            track = Stack(
              children: [
                Container(
                  height: sliderThickness,
                  color: AppColorScheme.of(
                    context,
                  ).byRole(ColorRole.of(context)).pressedColor,
                ),

                Container(
                  width: activeTrackLength,
                  height: sliderThickness,
                  color: AppColorScheme.of(
                    context,
                  ).byRole(ColorRole.of(context)).onEnabledColor,
                ),
              ],
            );
          } else {
            track = Container(decoration: BoxDecoration(gradient: gradient));
          }

          return Stack(
            children: [
              /// track
              Positioned(
                left: 0,
                top: 0.5 * sliderThickness,
                right: 0,
                height: sliderThickness,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(smallBorderRadius),
                  child: track,
                ),
              ),

              /// thumb
              Positioned(
                left: thumbLeft, // length - sliderThickness,
                top: 0,
                width: 2 * sliderThickness,
                height: 2 * sliderThickness,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sliderThickness),
                    color: AppColorScheme.of(
                      context,
                    ).byRole(ColorRole.of(context)).onEnabledColor,
                  ),
                  width: 2 * sliderThickness,
                  height: 2 * sliderThickness,
                ),
              ),

              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 2 * sliderThickness,
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    allowedInteraction: allowedInteraction,
                    onChanged: onChanged,
                    onChangeStart: onChangeStart,
                    onChangeEnd: onChangeEnd,
                    semanticFormatterCallback: semanticFormatterCallback,
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    thumbColor: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AppDropdown extends StatefulWidget{
  final MenuController? controller;
  final AlignmentGeometry? alignment;
  final double borderRadius;
  final List<Widget> Function(BuildContext, MenuController) childrenBuilder;
  final Widget Function(BuildContext, MenuController, Widget?)? builder;
  final Widget? child;

  const AppDropdown({
    super.key,
    this.controller,
    this.alignment,
    this.borderRadius = smallPadding,
    required this.childrenBuilder,
    this.builder,
    this.child,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  late final MenuController controller;

  @override
  void initState(){
    super.initState();
    controller = widget.controller ?? MenuController();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius)),
        ),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
        backgroundColor: WidgetStateProperty.all(
          AppColorScheme.of(context).byRole(ColorRole.of(context)).color,
        ),
        alignment: widget.alignment,
      ),
      controller: controller,
      menuChildren: [
        FadeIn(
          offsetBegin: Offset(0, -20),
          opacityBegin: 0.7,
          child: SmoothPointerScroll(
            builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                physics: physics,
                child: AppFloatingIndicatorButtonGroup(
                  child: Column(
                    children: widget.childrenBuilder(context, controller),
                  ),
                ),
              );
            },
          ),
        ),
      ],
      builder: widget.builder,
      child: widget.child,
    );
  }
}

class AppMapViewer extends StatefulWidget {
  final String assetName;
  final Size imageSize;
  final Offset markerPixel;
  final double minScale;
  final double maxScale;
  final double? initScale;
  final double iconSize;

  const AppMapViewer({
    super.key,
    required this.assetName,
    required this.imageSize,
    required this.markerPixel,
    this.minScale = 0.1,
    this.maxScale = 10,
    this.initScale,
    this.iconSize = 36,
  });

  @override
  State<AppMapViewer> createState() => _AppMapViewerState();
}

class _AppMapViewerState extends State<AppMapViewer> {
  final TransformationController _controller = TransformationController();
  final GlobalKey _viewerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setInitialTransform());
  }

  void _setInitialTransform() {
    final RenderBox? box =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Size viewerSize = box.size;
    final double scale =
        widget.initScale ?? viewerSize.width * 0.8 / widget.imageSize.width;

    final Offset translation = Offset(
      viewerSize.width / 2 - widget.markerPixel.dx * scale,
      viewerSize.height / 2 - widget.markerPixel.dy * scale,
    );

    _controller.value = Matrix4.identity()
      ..translate(translation.dx, translation.dy)
      ..scale(scale);
  }

  Offset _pixelToScreen(Offset pixel) {
    final matrix = _controller.value;
    final scale = matrix.getMaxScaleOnAxis();
    final dx = matrix.storage[12];
    final dy = matrix.storage[13];
    return Offset(pixel.dx * scale + dx, pixel.dy * scale + dy);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          InteractiveViewer(
            key: _viewerKey,
            transformationController: _controller,
            constrained: false,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            onInteractionUpdate: (_) => setState(() {}),
            child: Image.asset(
              widget.assetName,
              width: widget.imageSize.width,
              height: widget.imageSize.height,
              fit: BoxFit.fill,
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final screenPos = _pixelToScreen(widget.markerPixel);
              return Positioned(
                left: screenPos.dx - widget.iconSize * 0.5,
                top: screenPos.dy - widget.iconSize,
                child: child!,
              );
            },
            child: IgnorePointer(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: widget.iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppRawSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;

  const AppRawSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        thumbColor: WidgetStateProperty.fromMap({
          WidgetState.selected: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).color,
          WidgetState.selected & WidgetState.hovered: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).hoveredColor,
          WidgetState.selected & WidgetState.pressed: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).pressedColor,
          ~WidgetState.selected: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onColor,
          ~WidgetState.selected & WidgetState.hovered: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onHoveredColor,
          ~WidgetState.selected & WidgetState.pressed: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onPressedColor,
        }),
        trackColor: WidgetStateProperty.fromMap({
          ~WidgetState.selected: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).color,
          ~WidgetState.selected & WidgetState.hovered: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).hoveredColor,
          ~WidgetState.selected & WidgetState.pressed: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).pressedColor,
          WidgetState.selected: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onColor,
          WidgetState.selected & WidgetState.hovered: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onHoveredColor,
          WidgetState.selected & WidgetState.pressed: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onPressedColor,
        }),
        trackOutlineColor: WidgetStateProperty.fromMap({
          WidgetState.any: AppColorScheme.of(
            context,
          ).byRole(ColorRole.of(context)).onColor,
        }),
      ),
    );
  }
}

class AppSwitchButton extends StatefulWidget{
  final Duration duration;
  final Curve curve;

  final bool value;
  final void Function(bool)? onChanged;
  final bool expand;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final ColorRole? colorRole;
  final bool isTransparent;
  final bool useConfiguration;

  final String? toolTip;
  final bool isTranslate;
  final List<LogicalKeyboardKey>? toolTipShortcut;
  final bool usable;
  final Widget? child;

  const AppSwitchButton({
    super.key,
    this.duration = animationTime,
    this.curve = Curves.linear,
    required this.value,
    this.onChanged,
    this.expand = true,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: smallPadding),
    this.width,
    this.height = smallButtonSize,
    this.constraints,
    this.margin,
    this.borderRadius = smallBorderRadius,
    this.colorRole,
    this.isTransparent = true,
    this.useConfiguration = true,
    this.toolTip,
    this.toolTipShortcut,
    this.isTranslate = true,
    this.usable = true,
    this.child,
  });

  @override
  State<AppSwitchButton> createState() => _AppSwitchButtonState();
}

class _AppSwitchButtonState extends State<AppSwitchButton>{
  @override
  Widget build(BuildContext context){
    final Widget switchWidget = AppRawSwitch(value: widget.value);

    return AppButton(
      key: widget.key,
      duration: widget.duration,
      curve: widget.curve,
      alignment: widget.alignment,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      margin: widget.margin,
      borderRadius: widget.borderRadius,
      colorRole: widget.colorRole,
      isTransparent: widget.isTransparent,
      useConfiguration: widget.useConfiguration,
      toolTip: widget.toolTip,
      isTranslate: widget.isTranslate,
      toolTipShortcut: widget.toolTipShortcut,
      usable: widget.usable,
      onClick: (){
        setState((){
          widget.onChanged?.call(!widget.value);
        });
      },
      child: widget.child == null ? switchWidget : Row(
        children: [
          Expanded(child: widget.child!),

          switchWidget,
        ],
      ),
    );
  }
}

class AppCachedNetworkImage extends StatelessWidget{
  final String imageUrl;
  final String? cacheKey;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.cacheKey,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
  });

  @override
  Widget build(BuildContext context){
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      fadeInDuration: animationTime,
      fadeOutDuration: animationTime,
      errorWidget: (BuildContext context, String url, Object error){
        return Center(
          child: AppText("?"),
        );
      },
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }
}

class AppSuperTooltip extends StatelessWidget{
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final ColorRole colorRole;
  final TooltipDirection direction;
  final Widget content;
  final Widget child;

  const AppSuperTooltip({
    super.key,
    this.padding = const EdgeInsets.all(smallPadding),
    this.width,
    this.height,
    this.colorRole = ColorRole.background,
    this.direction = TooltipDirection.auto,
    required this.content,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return SuperTooltip(
      style: TooltipStyle(
        backgroundColor: AppColorScheme.of(context).byRole(colorRole).color,
        borderRadius: smallBorderRadius,
        borderColor: Colors.transparent,
        shadowColor: Colors.black12,
        bubbleDimensions: const EdgeInsets.all(0),
      ),
      positionConfig: PositionConfiguration(
        preferredDirection: direction,
      ),
      barrierConfig: BarrierConfiguration(
        color: Colors.transparent,
      ),
      animationConfig: AnimationConfiguration(
        fadeInDuration: animationTime,
        fadeOutDuration: animationTime,
      ),
      content: Padding(
        padding: padding,
        child: SizedBox(
          width: width,
          height: height,
          child: content,
        ),
      ),
      child: child,
    );
  }
}

class AppTab extends StatefulWidget{
  final Axis direction;
  final double spacing;
  final int initIndex;
  final Duration duration;
  final Curve curve;
  final List<({Widget nav, Widget page})> children;

  const AppTab({
    super.key,
    this.direction = Axis.horizontal,
    this.spacing = listSpacing,
    this.initIndex = 0,
    this.duration = animationTime,
    this.curve = animationCurve,
    required this.children,
  });

  @override
  State<AppTab> createState() => _AppTabState();
}

class _AppTabState extends State<AppTab>{
  final List<Widget> navList = [];
  final List<Widget> pageList = [];
  late int currentPage;
  late final PageController controller;

  @override
  void initState(){
    super.initState();

    currentPage = widget.initIndex;
    controller = PageController(initialPage: widget.initIndex);

    for(final (index, child) in widget.children.indexed){
      navList.add(GestureDetector(
        onTap: (){
          currentPage = index;
          controller.animateToPage(index, duration: widget.duration, curve: widget.curve);
        },
        child: child.nav,
      ));
      pageList.add(child.page);
    }
  }

  @override
  Widget build(BuildContext context){
    final List<Widget> children = [
      ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child){
          return AppRadioStack(
            direction: widget.direction,
            selectedIndex: currentPage,
            children: navList,
          );
        },
      ),

      Expanded(
        child: PageView.builder(
          scrollDirection: widget.direction,
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pageList.length,
          itemBuilder: (BuildContext context, int index) => pageList[index],
        ),
      ),
    ];

    return Flex(
      direction: widget.direction == Axis.horizontal ? Axis.vertical : Axis.horizontal,
      spacing: widget.spacing,
      children: children,
    );
  }
}

