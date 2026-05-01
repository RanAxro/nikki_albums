import "package:nikki_albums/widgets/common/component.dart";

import "component.dart";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";

class SmallDivider extends StatelessWidget {
  final Color color;
  const SmallDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: smallPadding,
      endIndent: smallPadding,
      color: color,
    );
  }
}

class SmallVerticalDivider extends StatelessWidget {
  final Color color;
  const SmallVerticalDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 1,
      thickness: 1,
      indent: smallPadding,
      endIndent: smallPadding,
      color: color,
    );
  }
}

class AppDivider extends StatelessWidget {
  final Axis direction;
  final double thickness;

  const AppDivider({
    super.key,
    this.direction = Axis.horizontal,
    this.thickness = smallDividerThickness,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.horizontal
        ? VerticalDivider(
            width: thickness,
            thickness: thickness,
            indent: smallPadding,
            endIndent: smallPadding,
            color: AppColorScheme.of(
              context,
            ).byRole(ColorRole.of(context)).onDisabledColor,
          )
        : Divider(
            height: thickness,
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
          if (waitingBuilder != null)
            return waitingBuilder!(context, indicator);
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
                if (progress != null && progress >= 1)
                  Navigator.of(context).pop();
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

class ContainerStyle {
  static final ContainerStyle defaultStyle = ContainerStyle();

  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  ContainerStyle({
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  });

  static ContainerStyle merge(
    ContainerStyle targetStyle,
    ContainerStyle otherStyle,
  ) {
    return ContainerStyle(
      alignment: otherStyle.alignment ?? targetStyle.alignment,
      padding: otherStyle.padding ?? targetStyle.padding,
      color: otherStyle.color ?? targetStyle.color,
      decoration: otherStyle.decoration ?? targetStyle.decoration,
      foregroundDecoration:
          otherStyle.foregroundDecoration ?? targetStyle.foregroundDecoration,
      width: otherStyle.width ?? targetStyle.width,
      height: otherStyle.height ?? targetStyle.height,
      constraints: otherStyle.constraints ?? targetStyle.constraints,
      margin: otherStyle.margin ?? targetStyle.margin,
      transform: otherStyle.transform ?? targetStyle.transform,
      transformAlignment:
          otherStyle.transformAlignment ?? targetStyle.transformAlignment,
      clipBehavior: otherStyle.clipBehavior,
    );
  }
}

////////////////////
//     Button     //
////////////////////

// class RButton extends StatefulWidget{
//   final Duration duration;
//   final Curve curve;
//   final ContainerStyle? style;
//   final ContainerStyle? enabledStyle;
//   final ContainerStyle? disabledStyle;
//   final ContainerStyle? hoveredStyle;
//   final ContainerStyle? pressedStyle;
//   final List<int> pressedStyleButtons;
//   final bool usable;
//   final Widget? child;
//   final Widget? Function(BuildContext context, Widget? child, bool isInside, bool isPressed)? common;
//
//   const RButton({
//     super.key,
//     this.curve = Curves.linear,
//     this.duration = Duration.zero,
//     this.style,
//     this.enabledStyle,
//     this.disabledStyle,
//     this.hoveredStyle,
//     this.pressedStyle,
//     this.pressedStyleButtons = const [kPrimaryMouseButton],
//     this.usable = true,
//     this.child,
//     this.common,
//   });
//
//   @override
//   State<RButton> createState() => _RButtonState();
// }
// class _RButtonState extends State<RButton>{
//   bool isInside = false;
//   bool isPressed = false;
//
//   void onMouseEnter(){
//     isInside = true;
//   }
//
//   void onMouseExit(){
//     isInside = false;
//     isPressed = false;
//   }
//
//   void onPointerDown(int pressedButton){
//     if(widget.pressedStyleButtons.contains(pressedButton)){
//       isPressed = true;
//     }
//   }
//
//   void onPointerUp(){
//     isPressed = false;
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return MouseRegion(
//       cursor: widget.usable ? SystemMouseCursors.click : SystemMouseCursors.basic,
//       onEnter: (PointerEnterEvent event){
//         setState((){
//           onMouseEnter();
//         });
//       },
//       onExit: (PointerExitEvent event){
//         setState((){
//           onMouseExit();
//         });
//       },
//       child: Listener(
//         onPointerDown: (PointerDownEvent event){
//           setState((){
//             onPointerDown(event.buttons);
//           });
//         },
//         onPointerUp: (PointerUpEvent event){
//           setState((){
//             onPointerUp();
//           });
//         },
//         onPointerCancel: (PointerCancelEvent event){
//           setState((){
//             onPointerUp();
//           });
//         },
//         child: Builder(
//           common: (BuildContext context){
//             ContainerStyle actionStyle = (widget.usable ? widget.enabledStyle : widget.disabledStyle) ?? ContainerStyle.defaultStyle;
//
//             if(widget.usable && isInside && widget.hoveredStyle != null){
//               actionStyle = widget.hoveredStyle!;
//             }
//
//             if(widget.usable && isPressed && widget.pressedStyle != null){
//               actionStyle = widget.pressedStyle!;
//             }
//
//             ContainerStyle style = widget.style == null ? actionStyle : ContainerStyle.merge(widget.style!, actionStyle);
//
//             return AnimatedContainer(
//               duration: widget.duration,
//               curve: widget.curve,
//               alignment:style.alignment,
//               padding: style.padding,
//               color: style.color,
//               decoration: style.decoration,
//               foregroundDecoration: style.foregroundDecoration,
//               width: style.width,
//               height: style.height,
//               constraints: style.constraints,
//               margin: style.margin,
//               transform: style.transform,
//               transformAlignment: style.transformAlignment,
//               clipBehavior: style.clipBehavior,
//               child: widget.common == null ? widget.child : widget.common!(context, widget.child, isInside, isPressed),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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
  Function(bool usable, bool isInside, bool isPressed)?
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
  Function(bool usable, bool isInside, bool isPressed)?
  shader;
  final bool useConfiguration;

  final String? toolTip;
  final bool isTranslate;
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
    this.usable = true,
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
        widget.shader?.call(widget.usable, isInside, isPressed) ??
        style?.shader?.call(widget.usable, isInside, isPressed) ??
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
          Radius.circular(widget.borderRadius ?? style?.borderRadius ?? 0),
        ),
        color: isTransparent
            ? AppColorScheme.of(
                context,
              ).byRole(colorRole).byState(colorState).withAlpha(0)
            : AppColorScheme.of(context).byRole(colorRole).byState(colorState),
      ),
      width: widget.width ?? style?.width,
      height: widget.height ?? style?.height,
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
      button = Tooltip(
        message: widget.isTranslate
            ? context.tr(widget.toolTip!)
            : widget.toolTip,
        child: button,
      );
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

// class AppButton extends StatefulWidget{
//   final Duration duration;
//   final Curve curve;
//
//   final AlignmentGeometry alignment;
//   final EdgeInsetsGeometry? padding;
//   final double? width;
//   final double? height;
//   final BoxConstraints? constraints;
//   final EdgeInsetsGeometry? margin;
//   final double borderRadius;
//   final ColorRole? colorRole;
//   final bool transparent;
//
//   final String? toolTip;
//   final bool isTranslate;
//   final bool usable;
//   final void Function()? onClick;
//   final Widget? child;
//   final Widget? Function(BuildContext context, Widget? child, bool isHovered, bool isPressed)? common;
//
//   const AppButton({
//     super.key,
//     this.duration = const Duration(milliseconds: 100),
//     this.curve = Curves.linear,
//     this.alignment = Alignment.center,
//     this.padding,
//     this.width,
//     this.height,
//     this.constraints,
//     this.margin,
//     this.borderRadius = smallBorderRadius,
//     this.colorRole,
//     this.transparent = true,
//     this.toolTip,
//     this.isTranslate = true,
//     this.usable = true,
//     this.onClick,
//     this.child,
//     this.common,
//   });
//
//   @override
//   State<AppButton> createState() => _AppButtonState();
// }
// class _AppButtonState extends State<AppButton>{
//   bool isInside = false;
//   bool isPressed = false;
//
//   void onMouseEnter(){
//     isInside = true;
//   }
//
//   void onMouseExit(){
//     isInside = false;
//     isPressed = false;
//   }
//
//   void onPointerDown(int pressedButton){
//     if(pressedButton == kPrimaryMouseButton){
//       isPressed = true;
//     }
//   }
//
//   void onPointerUp(){
//     isPressed = false;
//   }
//
//   @override
//   Widget build(BuildContext context){
//
//     ColorRole colorRole = widget.colorRole ?? ColorRole.of(context);
//     ColorState colorState = ColorState.normal;
//     bool transparent = widget.usable ? widget.transparent && !isInside && !isPressed : widget.transparent;
//
//     if(widget.usable){
//       colorState = ColorState.enabled;
//
//       if(isInside){
//         colorState = ColorState.hovered;
//       }
//       if(isPressed){
//         colorState = ColorState.pressed;
//       }
//     }else{
//       colorState = ColorState.disabled;
//     }
//
//     final Widget? child = widget.common?.call(context, widget.child, isInside, isPressed) ?? widget.child;
//
//     Widget button = AnimatedContainer(
//       duration: widget.duration,
//       curve: widget.curve,
//       alignment: widget.alignment,
//       padding: widget.padding,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
//         color: transparent ? AppColorScheme.of(context).byRole(colorRole).byState(colorState).withAlpha(0) : AppColorScheme.of(context).byRole(colorRole).byState(colorState),
//       ),
//       width: widget.width,
//       height: widget.height,
//       constraints: widget.constraints,
//       margin: widget.margin,
//       child: child == null ? null : AppThemeState(
//         colorState: colorState,
//         child: child,
//       ),
//     );
//
//     if(widget.toolTip != null && widget.usable){
//       button = Tooltip(
//         message: widget.isTranslate ? context.tr(widget.toolTip!) : widget.toolTip,
//         child: button,
//       );
//     }
//
//
//     return GestureDetector(
//       onTap: widget.usable ? widget.onClick : null,
//       child: MouseRegion(
//         cursor: widget.usable ? SystemMouseCursors.click : SystemMouseCursors.basic,
//         onEnter: (PointerEnterEvent event){
//           setState((){
//             onMouseEnter();
//           });
//         },
//         onExit: (PointerExitEvent event){
//           setState((){
//             onMouseExit();
//           });
//         },
//         child: Listener(
//           onPointerDown: (PointerDownEvent event){
//             setState((){
//               onPointerDown(event.buttons);
//             });
//           },
//           onPointerUp: (PointerUpEvent event){
//             setState((){
//               onPointerUp();
//             });
//           },
//           onPointerCancel: (PointerCancelEvent event){
//             setState((){
//               onPointerUp();
//             });
//           },
//           child: button,
//         ),
//       ),
//     );
//   }
// }

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
      shader: (bool usable, bool isInside, bool isPressed) {
        return shader(context, usable, isInside, isPressed);
      },
      useConfiguration: useConfiguration,
      toolTip: toolTip,
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
      usable: usable,
      onClick: onClick,
      builder: builder,
      child: child,
    );
  }
}

class AppButtonStack extends StatefulWidget {
  final Duration duration;
  final Axis direction;
  final double spacing;
  final double? buttonWidth;
  final double? buttonHeight;
  final double borderRadius;
  final List<int>? divider;
  final List<Widget> children;
  // final List<AppRawButton> children;

  const AppButtonStack({
    super.key,
    this.duration = animationTime,
    this.direction = Axis.horizontal,
    this.spacing = 0.0,
    this.buttonWidth = smallButtonSize,
    this.buttonHeight = smallButtonSize,
    this.borderRadius = smallBorderRadius,
    this.divider,
    required this.children,
  }) : assert(
         direction == Axis.horizontal && buttonWidth != null ||
             direction == Axis.vertical && buttonHeight != null,
         direction == Axis.horizontal
             ? "AppButtonStack: if direction == Axis.horizontal, buttonWidth != null"
             : "AppButtonStack: if direction == Axis.vertical, buttonHeight != null",
       );

  @override
  State<AppButtonStack> createState() => _AppButtonStackState();
}

class _AppButtonStackState extends State<AppButtonStack> {
  int? lastIndex;
  final ValueNotifier<int?> hoverIndex = ValueNotifier(null);
  late final AppButtonStyle style;

  @override
  void initState() {
    super.initState();
    style = AppButtonStyle(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      shader: (bool usable, bool isInside, bool isPressed) {
        ColorRole colorRole = ColorRole.of(context);
        ColorState colorState = ColorState.normal;
        bool isTransparent = true;

        if (usable) {
          colorState = ColorState.enabled;
          if (isInside) {
            colorState = ColorState.hovered;
          }
          if (isPressed) {
            colorState = ColorState.pressed;
            isTransparent = false;
          }
        } else {
          colorState = ColorState.disabled;
        }

        return (colorRole, colorState, isTransparent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < widget.children.length; index++) {
      children.add(
        MouseRegion(
          onEnter: (_) {
            lastIndex = hoverIndex.value;
            hoverIndex.value = index;
          },
          child: widget.children[index],
        ),
      );
    }

    /// [widget.direction == Axis.horizontal ? widget.buttonWidth : widget.buttonHeight] can not be [null] because of assert.
    final double wholeSpacing =
        widget.spacing +
        ((widget.direction == Axis.horizontal
                ? widget.buttonWidth
                : widget.buttonHeight) ??
            0);

    final List<double> dividerOffset = [];
    if (widget.divider != null) {
      int counter = 0;
      for (final int interval in widget.divider!) {
        counter += interval;
        dividerOffset.add(counter * wholeSpacing);
      }
    }

    final Stack stack = Stack(
      children: [
        /// Indicator
        ValueListenableBuilder(
          valueListenable: hoverIndex,
          builder: (BuildContext context, int? index, Widget? child) {
            late final double offset;
            late final bool transparent;
            late final Duration moveDuration;

            /// Start hovering
            if (lastIndex == null && index != null) {
              offset = index * wholeSpacing;
              transparent = false;
              moveDuration = Duration.zero;
            }
            /// Stop hovering
            else if (lastIndex != null && index == null) {
              offset = lastIndex! * wholeSpacing;
              transparent = true;
              moveDuration = widget.duration;
            }
            /// Is hovering
            else if (lastIndex != null && index != null) {
              offset = index * wholeSpacing;
              transparent = false;
              moveDuration = widget.duration;
            }
            /// No hovering
            else {
              // It will never come to this code block.
              offset = 0;
              transparent = true;
              moveDuration = Duration.zero;
            }

            return AnimatedPositioned(
              duration: moveDuration,
              left: widget.direction == Axis.horizontal ? offset : 0,
              top: widget.direction == Axis.vertical ? offset : 0,
              right: widget.direction == Axis.horizontal ? null : 0,
              bottom: widget.direction == Axis.vertical ? null : 0,
              width: widget.direction == Axis.horizontal
                  ? widget.buttonWidth
                  : null,
              height: widget.direction == Axis.vertical
                  ? widget.buttonHeight
                  : null,
              child: Center(
                child: AnimatedContainer(
                  duration: widget.duration,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    color: transparent
                        ? AppColorScheme.of(context)
                              .byRole(ColorRole.of(context))
                              .hoveredColor
                              .withAlpha(0)
                        : AppColorScheme.of(
                            context,
                          ).byRole(ColorRole.of(context)).hoveredColor,
                  ),
                  width: widget.buttonWidth,
                  height: widget.buttonHeight,
                ),
              ),
            );
          },
        ),

        /// TODO 滚动时不要触发exit
        MouseRegion(
          onExit: (_) {
            lastIndex = hoverIndex.value;
            hoverIndex.value = null;
          },
          child: AppButtonConfiguration(
            style: style,
            child: widget.direction == Axis.horizontal
                ? Row(
                    spacing: widget.spacing,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  )
                : Column(
                    spacing: widget.spacing,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
          ),
        ),

        /// Divider
        for (final double offset in dividerOffset)
          Positioned(
            left: widget.direction == Axis.horizontal
                ? offset - 0.5 * smallDividerThickness
                : 0,
            top: widget.direction == Axis.vertical
                ? offset - 0.5 * smallDividerThickness
                : 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppDivider(direction: widget.direction, thickness: 1),
              ),
            ),
          ),
      ],
    );

    return Center(
      child: SizedBox(
        width: widget.direction == Axis.vertical ? widget.buttonWidth : null,
        height: widget.direction == Axis.horizontal
            ? widget.buttonHeight
            : null,
        child: stack,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    hoverIndex.dispose();
  }
}

class SmallButton extends StatelessWidget {
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;

  final double borderRadius;
  final ColorRole colorRole;
  final bool transparent;
  final bool usable;
  final void Function()? onClick;
  final Widget? child;
  final Widget? Function(
    BuildContext context,
    Widget? child,
    bool isInside,
    bool isPressed,
  )?
  builder;
  final Widget? Function(
    BuildContext context,
    Color onButtonColor,
    Widget? child,
  )?
  colorBuilder;

  const SmallButton({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.padding,
    this.width = smallButtonSize,
    this.height = smallButtonSize,
    this.constraints,
    this.margin,
    this.borderRadius = smallBorderRadius,
    this.colorRole = ColorRole.primary,
    this.transparent = true,
    this.usable = true,
    this.onClick,
    this.child,
    this.builder,
    this.colorBuilder,
  }) : assert(
         builder == null || colorBuilder == null,
         "colorBuilder不能同时拥有builder与colorBuilder",
       );

  @override
  Widget build(BuildContext context) {
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
      isTransparent: transparent,
      colorRole: colorRole,
      usable: usable,
      onClick: onClick,
      builder: builder,
      child: child,
    );
  }
}

// class SmallButton extends StatelessWidget{
//   final Duration duration;
//   final Curve curve;
//
//   final AlignmentGeometry alignment;
//   final EdgeInsetsGeometry? padding;
//   final double? width;
//   final double? height;
//   final BoxConstraints? constraints;
//   final EdgeInsetsGeometry? margin;
//
//   final double borderRadius;
//   final ColorRoles colorRole;
//   final bool transparent;
//   final bool usable;
//   final void Function()? onClick;
//   final Widget? child;
//   final Widget? Function(BuildContext context, Widget? child, bool isInside, bool isPressed)? common;
//   final Widget? Function(BuildContext context, Color onButtonColor, Widget? child)? colorBuilder;
//
//   const SmallButton({
//     super.key,
//     this.duration = const Duration(milliseconds: 100),
//     this.curve = Curves.linear,
//     this.alignment = Alignment.center,
//     this.padding,
//     this.width = smallButtonSize,
//     this.height = smallButtonSize,
//     this.constraints,
//     this.margin,
//     this.borderRadius = smallBorderRadius,
//     this.colorRole = ColorRoles.primary,
//     this.transparent = true,
//     this.usable = true,
//     this.onClick,
//     this.child,
//     this.common,
//     this.colorBuilder
//   }) :
//     assert(common == null || colorBuilder == null, "colorBuilder不能同时拥有builder与colorBuilder");
//
//   @override
//   Widget build(BuildContext context){
//     return GestureDetector(
//       onTap: usable ? onClick : null,
//       child: RButton(
//         duration: duration,
//         curve: curve,
//         style: ContainerStyle(
//           alignment: alignment,
//           padding: padding,
//           width: width,
//           height: height,
//           constraints: constraints,
//           margin: margin,
//         ),
//         enabledStyle: ContainerStyle(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//             color: transparent ? AppTheme.of(context)!.colorScheme.byRole(colorRole).enabledColor.withAlpha(0) : AppTheme.of(context)!.colorScheme.byRole(colorRole).enabledColor,
//           ),
//         ),
//         disabledStyle: ContainerStyle(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//             color: transparent ? AppTheme.of(context)!.colorScheme.byRole(colorRole).disabledColor.withAlpha(0) : AppTheme.of(context)!.colorScheme.byRole(colorRole).disabledColor,
//           ),
//         ),
//         hoveredStyle: ContainerStyle(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//             color: AppTheme.of(context)!.colorScheme.byRole(colorRole).hoveredColor,
//           ),
//         ),
//         pressedStyle: ContainerStyle(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//             color: AppTheme.of(context)!.colorScheme.byRole(colorRole).pressedColor,
//           ),
//         ),
//         usable: usable,
//         common: common ?? (colorBuilder == null ? null : (BuildContext context, Widget? child, bool isInside, bool isPressed) => colorBuilder!.call(
//           context,
//           !usable ? AppTheme.of(context)!.colorScheme.byRole(colorRole).onDisabledColor :
//             isPressed ? AppTheme.of(context)!.colorScheme.byRole(colorRole).onPressedColor :
//             isInside ? AppTheme.of(context)!.colorScheme.byRole(colorRole).onHoveredColor :
//             AppTheme.of(context)!.colorScheme.byRole(colorRole).onEnabledColor,
//           child,
//         )),
//         child: child,
//       ),
//     );
//   }
// }

////////////////////
//     Switch     //
////////////////////

class RSwitch extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final ContainerStyle? offStyle;
  final ContainerStyle? onStyle;
  final ContainerStyle? hoveredStyle;
  final bool value;
  final bool usable;
  final Widget? child;
  final void Function(bool value)? onChange;
  final Widget? Function(BuildContext context, Widget? child, bool value)?
  builder;

  const RSwitch({
    super.key,
    this.curve = Curves.linear,
    this.duration = Duration.zero,
    this.offStyle,
    this.onStyle,
    this.hoveredStyle,
    this.value = false,
    this.usable = true,
    this.child,
    this.onChange,
    this.builder,
  });

  @override
  State<RSwitch> createState() => _RSwitchState();
}

class _RSwitchState extends State<RSwitch> {
  bool isInside = false;
  bool value = false;

  void onMouseEnter() {
    isInside = true;
  }

  void onMouseExit() {
    isInside = false;
  }

  void toggle() {
    value = !value;
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: GestureDetector(
        onTap: () {
          setState(() {
            toggle();
          });
        },
        child: Builder(
          builder: (BuildContext context) {
            ContainerStyle style =
                (value ? widget.onStyle : widget.offStyle) ??
                ContainerStyle.defaultStyle;
            ContainerStyle actionStyle = style;

            if (!value &&
                widget.usable &&
                isInside &&
                widget.hoveredStyle != null) {
              actionStyle = widget.hoveredStyle!;
            }

            style = ContainerStyle.merge(style, actionStyle);

            return AnimatedContainer(
              duration: widget.duration,
              curve: widget.curve,
              alignment: style.alignment,
              padding: style.padding,
              color: style.color,
              decoration: style.decoration,
              foregroundDecoration: style.foregroundDecoration,
              width: style.width,
              height: style.height,
              constraints: style.constraints,
              margin: style.margin,
              transform: style.transform,
              transformAlignment: style.transformAlignment,
              clipBehavior: style.clipBehavior,
              child: widget.builder == null
                  ? widget.child
                  : widget.builder!(context, widget.child, value),
            );
          },
        ),
      ),
    );
  }
}

class SmallSwitch extends StatelessWidget {
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;

  final double borderRadius;
  final ColorRole colorRole;
  final bool value;
  final bool usable;
  final void Function(bool value)? onChange;
  final Widget? child;
  final Widget? Function(BuildContext context, Widget? child, bool valued)?
  builder;

  const SmallSwitch({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.padding,
    this.width = smallButtonSize,
    this.height = smallButtonSize,
    this.constraints,
    this.margin,
    this.borderRadius = smallBorderRadius,
    this.colorRole = ColorRole.primary,
    this.value = false,
    this.usable = true,
    this.onChange,
    this.child,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return RSwitch(
      duration: duration,
      curve: curve,
      offStyle: ContainerStyle(
        alignment: alignment,
        padding: padding,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: AppTheme.of(context)!.colorScheme.byRole(colorRole).color,
        ),
      ),
      onStyle: ContainerStyle(
        alignment: alignment,
        padding: padding,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: AppTheme.of(
            context,
          )!.colorScheme.byRole(colorRole).pressedColor,
        ),
      ),
      hoveredStyle: ContainerStyle(
        alignment: alignment,
        padding: padding,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: AppTheme.of(
            context,
          )!.colorScheme.byRole(colorRole).hoveredColor,
        ),
      ),
      value: value,
      usable: usable,
      onChange: onChange,
      builder: builder,
      child: child,
    );
  }
}

// class AppSwitch extends StatefulWidget{
//   final Duration duration;
//   final Curve curve;
//
//   final AlignmentGeometry alignment;
//   final EdgeInsetsGeometry? padding;
//   final double? width;
//   final double? height;
//   final BoxConstraints? constraints;
//   final EdgeInsetsGeometry? margin;
//   final double borderRadius;
//   final ColorRole? colorRole;
//   final bool transparent;
//
//   final bool isOpen;
//   final String? toolTip;
//   final bool isTranslate;
//   final bool usable;
//   final void Function()? onClick;
//   final Widget? child;
//   final Widget? Function(BuildContext context, Widget? child, bool isHovered, bool isPressed)? common;
//
//   const AppSwitch({
//     super.key,
//     this.duration = const Duration(milliseconds: 100),
//     this.curve = Curves.linear,
//     this.alignment = Alignment.center,
//     this.padding,
//     this.width,
//     this.height,
//     this.constraints,
//     this.margin,
//     this.borderRadius = smallBorderRadius,
//     this.colorRole,
//     this.transparent = true,
//     this.isOpen = false,
//     this.toolTip,
//     this.isTranslate = true,
//     this.usable = true,
//     this.onClick,
//     this.child,
//     this.common,
//   });
//
//   @override
//   State<AppSwitch> createState() => _AppSwitchState();
// }
// class _AppSwitchState extends State<AppSwitch>{
//   bool isInside = false;
//   bool isPressed = false;
//
//   void onMouseEnter(){
//     isInside = true;
//   }
//
//   void onMouseExit(){
//     isInside = false;
//     isPressed = false;
//   }
//
//   void onPointerDown(int pressedButton){
//     if(pressedButton == kPrimaryMouseButton){
//       isPressed = true;
//     }
//   }
//
//   void onPointerUp(){
//     isPressed = false;
//   }
//
//   @override
//   Widget build(BuildContext context){
//
//     ColorRole colorRole = widget.colorRole ?? ColorRole.of(context);
//     ColorState colorState = ColorState.normal;
//     bool transparent = widget.usable ? widget.transparent && !isInside && !isPressed : widget.transparent;
//     if(widget.isOpen) transparent = false;
//
//     if(widget.usable){
//       colorState = widget.isOpen ? ColorState.pressed : ColorState.enabled;
//
//       if(isInside){
//         colorState = ColorState.hovered;
//       }
//       if(isPressed){
//         colorState = ColorState.hovered;
//       }
//     }else{
//       colorState = widget.isOpen ? ColorState.hovered : ColorState.disabled;
//     }
//
//     final Widget? child = widget.common?.call(context, widget.child, isInside, isPressed) ?? widget.child;
//
//     Widget button = AnimatedContainer(
//       duration: widget.duration,
//       curve: widget.curve,
//       alignment: widget.alignment,
//       padding: widget.padding,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
//         color: transparent ? AppColorScheme.of(context).byRole(colorRole).byState(colorState).withAlpha(0) : AppColorScheme.of(context).byRole(colorRole).byState(colorState),
//       ),
//       width: widget.width,
//       height: widget.height,
//       constraints: widget.constraints,
//       margin: widget.margin,
//       child: child == null ? null : AppThemeState(
//         colorState: colorState,
//         child: child,
//       ),
//     );
//
//     if(widget.toolTip != null && widget.usable){
//       button = Tooltip(
//         message: widget.isTranslate ? context.tr(widget.toolTip!) : widget.toolTip,
//         child: button,
//       );
//     }
//
//     return GestureDetector(
//       onTap: widget.usable ? widget.onClick : null,
//       child: MouseRegion(
//         cursor: widget.usable ? SystemMouseCursors.click : SystemMouseCursors.basic,
//         onEnter: (PointerEnterEvent event){
//           setState((){
//             onMouseEnter();
//           });
//         },
//         onExit: (PointerExitEvent event){
//           setState((){
//             onMouseExit();
//           });
//         },
//         child: Listener(
//           onPointerDown: (PointerDownEvent event){
//             setState((){
//               onPointerDown(event.buttons);
//             });
//           },
//           onPointerUp: (PointerUpEvent event){
//             setState((){
//               onPointerUp();
//             });
//           },
//           onPointerCancel: (PointerCancelEvent event){
//             setState((){
//               onPointerUp();
//             });
//           },
//           child: button,
//         ),
//       ),
//     );
//   }
// }

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
    bool isInside,
    bool isPressed,
  ) {
    ColorRole colorRole = this.colorRole ?? ColorRole.of(context);
    ColorState colorState = ColorState.normal;
    bool isTransparent = usable
        ? this.isTransparent && !isInside && !isPressed
        : this.isTransparent;

    if (usable) {
      if (value) {
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
      colorState = value ? ColorState.hovered : ColorState.disabled;
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
      shader: (bool usable, bool isInside, bool isPressed) {
        return shader(context, usable, isInside, isPressed);
      },
      toolTip: toolTip,
      usable: usable,
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

class AppRadioStack extends StatefulWidget {
  final Duration duration;
  final Axis direction;
  final double spacing;
  final double buttonWidth;
  final double buttonHeight;
  final double borderRadius;
  final List<int>? divider;
  final int? selectedIndex;
  final List<Widget> children;

  const AppRadioStack({
    super.key,
    this.duration = animationTime,
    this.direction = Axis.horizontal,
    this.spacing = .0,
    this.buttonWidth = smallButtonSize,
    this.buttonHeight = smallButtonSize,
    this.borderRadius = smallBorderRadius,
    this.divider,
    this.selectedIndex,
    required this.children,
  });

  @override
  State<AppRadioStack> createState() => _AppRadioStackState();
}

class _AppRadioStackState extends State<AppRadioStack> {
  int? lastIndex;
  final ValueNotifier<int?> hoverIndex = ValueNotifier(null);
  late final AppButtonStyle style;

  @override
  void initState() {
    super.initState();
    style = AppButtonStyle(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      borderRadius: widget.borderRadius,
      shader: (bool usable, bool isInside, bool isPressed) {
        ColorRole colorRole = ColorRole.of(context);
        ColorState colorState = ColorState.normal;
        bool isTransparent = true;

        if (usable) {
          colorState = ColorState.enabled;
          if (isInside) {
            colorState = ColorState.hovered;
          }
          if (isPressed) {
            colorState = ColorState.pressed;
            isTransparent = false;
          }
        } else {
          colorState = ColorState.disabled;
        }

        return (colorRole, colorState, isTransparent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < widget.children.length; index++) {
      children.add(
        MouseRegion(
          onEnter: (_) {
            lastIndex = hoverIndex.value;
            hoverIndex.value = index;
          },
          child: widget.children[index],
        ),
      );
    }

    final double wholeSpacing =
        widget.spacing +
        (widget.direction == Axis.horizontal
            ? widget.buttonWidth
            : widget.buttonHeight);

    final List<double> dividerOffset = [];
    if (widget.divider != null) {
      int counter = 0;
      for (final int interval in widget.divider!) {
        counter += interval;
        dividerOffset.add(counter * wholeSpacing);
      }
    }

    return Stack(
      children: [
        /// Block Indicator
        ValueListenableBuilder(
          valueListenable: hoverIndex,
          builder: (BuildContext context, int? index, Widget? child) {
            double offset = 0;
            bool transparent = true;

            if (widget.selectedIndex == null) {
              if (lastIndex == null && index != null) {
                offset = index * wholeSpacing;
                transparent = false;
              } else if (lastIndex != null && index == null) {
                offset = lastIndex! * wholeSpacing;
                transparent = true;
              } else if (lastIndex != null && index != null) {
                offset = index * wholeSpacing;
                transparent = false;
              } else {
                transparent = true;
              }
            } else {
              if (index == null) {
                offset = widget.selectedIndex! * wholeSpacing;
              } else {
                offset = index * wholeSpacing;
              }
              transparent = false;
            }

            return AnimatedPositioned(
              duration: lastIndex == null && widget.selectedIndex == null
                  ? Duration.zero
                  : widget.duration,
              left: widget.direction == Axis.horizontal ? offset : 0,
              top: widget.direction == Axis.vertical ? offset : 0,
              right: widget.direction == Axis.horizontal ? null : 0,
              bottom: widget.direction == Axis.vertical ? null : 0,
              child: Center(
                child: AnimatedContainer(
                  duration: widget.duration,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    color: transparent
                        ? AppColorScheme.of(context)
                              .byRole(ColorRole.of(context))
                              .hoveredColor
                              .withAlpha(0)
                        : AppColorScheme.of(
                            context,
                          ).byRole(ColorRole.of(context)).hoveredColor,
                  ),
                  width: widget.buttonWidth,
                  height: widget.buttonHeight,
                ),
              ),
            );
          },
        ),

        /// TODO 滚动时不要触发exit
        MouseRegion(
          onExit: (_) {
            lastIndex = hoverIndex.value;
            hoverIndex.value = null;
          },
          child: AppButtonConfiguration(
            style: style,
            child: widget.direction == Axis.horizontal
                ? Row(
                    spacing: widget.spacing,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  )
                : Column(
                    spacing: widget.spacing,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
          ),
        ),

        for (final double offset in dividerOffset)
          Positioned(
            left: widget.direction == Axis.horizontal
                ? offset - 0.5 * smallDividerThickness
                : 0,
            top: widget.direction == Axis.vertical
                ? offset - 0.5 * smallDividerThickness
                : 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppDivider(direction: widget.direction, thickness: 1),
              ),
            ),
          ),

        /// Indicator
        ValueListenableBuilder(
          valueListenable: hoverIndex,
          builder: (BuildContext context, int? index, Widget? child) {
            double offset = 0;
            bool transparent = true;

            if (widget.selectedIndex == null) {
              transparent = true;
            } else {
              offset = widget.selectedIndex! * wholeSpacing;
              transparent = false;
            }

            return AnimatedPositioned(
              duration: lastIndex == null && widget.selectedIndex == null
                  ? Duration.zero
                  : widget.duration,
              left: widget.direction == Axis.horizontal ? offset : 1,
              top: widget.direction == Axis.vertical ? offset : 1,
              width: widget.buttonWidth,
              height: widget.buttonHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: widget.duration,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    color: transparent
                        ? AppColorScheme.of(context)
                              .byRole(ColorRole.of(context))
                              .onHoveredColor
                              .withAlpha(0)
                        : AppColorScheme.of(
                            context,
                          ).byRole(ColorRole.of(context)).onHoveredColor,
                  ),
                  width: 2,
                  height: 0.5 * widget.buttonHeight,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    hoverIndex.dispose();
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

  const AppText(
    this.data, {
    super.key,
    this.isTranslate = true,
    this.fontSize,
    this.fontWeight,
  });

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

class RTextFiled extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ColorRole? colorRole;
  final void Function(String)? onChanged;
  const RTextFiled({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.colorRole,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFiled(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
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

class AppDropdown extends StatefulWidget {
  final MenuController? controller;
  final AlignmentGeometry? alignment;
  final double borderRadius;
  final double? buttonWidth;
  final double buttonHeight;
  final List<AppRawButton> children;
  final Widget Function(BuildContext, MenuController, Widget?)? builder;
  final Widget? child;

  const AppDropdown({
    super.key,
    this.controller,
    this.alignment,
    this.borderRadius = smallPadding,
    this.buttonWidth,
    this.buttonHeight = mediumButtonSize,
    required this.children,
    this.builder,
    this.child,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  late final MenuController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? MenuController();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
        backgroundColor: WidgetStateProperty.all(
          AppColorScheme.of(context).byRole(ColorRole.of(context)).color,
        ),
        alignment: widget.alignment,
      ),
      controller: controller,
      menuChildren: [
        SlideFadeIn(
          offsetBegin: Offset(0, -20),
          opacityBegin: 0.7,
          child: Stack(
            children: [
              Listener(
                behavior: HitTestBehavior.translucent,
                onPointerUp: (_) {
                  controller.close();
                },
                child: SmoothPointerScroll(
                  builder:
                      (
                        BuildContext context,
                        ScrollController controller,
                        ScrollPhysics physics,
                        IndependentScrollbarController scrollbarController,
                      ) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: controller,
                          physics: physics,
                          child: AppButtonStack(
                            direction: Axis.vertical,
                            buttonWidth: widget.buttonWidth,
                            buttonHeight: widget.buttonHeight,
                            borderRadius: 0,
                            children: widget.children,
                          ),
                        );
                      },
                ),
              ),
            ],
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
