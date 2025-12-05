import "package:easy_localization/easy_localization.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:nikkialbums/ui/theme.dart";


const double smallButtonSize = 36;
const double smallButtonContentSize = 20;
const double mediumButtonSize = 40;
const double mediumButtonContentSize = 34;
const double bigButtonSize = 80;
const double bigButtonContentSize = 62;

const double windowTitleBarHeight = smallButtonSize + 10;

const double topBarHeight = smallButtonSize + 8;
const double sideBarWidth = mediumButtonSize + 10;
const double sideBarExpandWidth = 200;

const double smallDialogMaxWidth = 400;
const double smallCardMaxWidth = 400;
const double smallCardMaxHeight = 100;

const double smallBorderRadius = 8;
const double smallPadding = 8;
const double bigPadding = 20;
const double listSpacing = 6;
const double bigListSpacing = 16;

const block0 = SizedBox(width: 0, height: 0);
const block5W = SizedBox(width: 5);
const block10W = SizedBox(width: 10);
const block5H = SizedBox(height: 5);
const block10H = SizedBox(height: 10);


class SmallDivider extends StatelessWidget{
  final Color color;
  const SmallDivider({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context){
    return Divider(
      height: 1,
      thickness: 1,
      indent: smallPadding,
      endIndent: smallPadding,
      color: color,
    );
  }
}

class SmallVerticalDivider extends StatelessWidget{
  final Color color;
  const SmallVerticalDivider({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context){
    return VerticalDivider(
      width: 1,
      thickness: 1,
      indent: smallPadding,
      endIndent: smallPadding,
      color: color,
    );
  }
}


class RFutureBuilder<T> extends StatelessWidget{
  final Future<T>? future;
  final Widget Function(BuildContext, Widget)? waitingBuilder;
  final Widget Function(BuildContext, T) builder;

  const RFutureBuilder({
    super.key,
    required this.future,
    this.waitingBuilder,
    required this.builder,
  });

  @override
  Widget build(BuildContext context){
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          final CircularProgressIndicator indicator = CircularProgressIndicator();
          if(waitingBuilder != null) return waitingBuilder!(context, indicator);
          return indicator;
        }
        if(snapshot.hasError){
          return block0;
        }
        return builder(context, snapshot.data as T);
      }
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
  Widget Function(BuildContext context, void Function() close)? completedBuilder,
}){
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context){

      final Widget? child = builder?.call(context);

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
            builder: (BuildContext context, double? progress, Widget? child){
              String text = title ?? "";
              if(progress != null){
                if(progress >= 1){
                  text += " ( ${context.tr("completed")} )";
                }else{
                  text += " ( ${(progress * 100).toInt()} % )";
                }
              }

              if((!barrierDismissible && completedBuilder == null) || autoClose){
                if(progress != null && progress >= 1) Navigator.of(context).pop();
              }

              return Column(
                spacing: bigListSpacing,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.of(context)!.colorScheme.primary.color,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.of(context)!.colorScheme.primary.onColor),
                    minHeight: 4,
                  ),
                  ?child,
                  if(progress != null && progress >= 1) ?completedBuilder?.call(context, () => Navigator.of(context).pop()),
                ],
              );
            },
          ),
        ),
      );
    }
  );
}


class ContainerStyle{
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

  static ContainerStyle merge(ContainerStyle targetStyle, ContainerStyle otherStyle){
    return ContainerStyle(
      alignment: otherStyle.alignment ?? targetStyle.alignment,
      padding: otherStyle.padding ?? targetStyle.padding,
      color: otherStyle.color ?? targetStyle.color,
      decoration: otherStyle.decoration ?? targetStyle.decoration,
      foregroundDecoration: otherStyle.foregroundDecoration ?? targetStyle.foregroundDecoration,
      width: otherStyle.width ?? targetStyle.width,
      height: otherStyle.height ?? targetStyle.height,
      constraints: otherStyle.constraints ?? targetStyle.constraints,
      margin: otherStyle.margin ?? targetStyle.margin,
      transform: otherStyle.transform ?? targetStyle.transform,
      transformAlignment: otherStyle.transformAlignment ?? targetStyle.transformAlignment,
      clipBehavior: otherStyle.clipBehavior,
    );
  }
}


////////////////////
//     Button     //
////////////////////

class RButton extends StatefulWidget{
  final Duration duration;
  final Curve curve;
  final ContainerStyle? style;
  final ContainerStyle? enabledStyle;
  final ContainerStyle? disabledStyle;
  final ContainerStyle? hoveredStyle;
  final ContainerStyle? pressedStyle;
  final List<int> pressedStyleButtons;
  final bool usable;
  final Widget? child;
  final Widget? Function(BuildContext context, Widget? child, bool isInside, bool isPressed)? builder;

  const RButton({
    super.key,
    this.curve = Curves.linear,
    this.duration = Duration.zero,
    this.style,
    this.enabledStyle,
    this.disabledStyle,
    this.hoveredStyle,
    this.pressedStyle,
    this.pressedStyleButtons = const [kPrimaryMouseButton],
    this.usable = true,
    this.child,
    this.builder,
  });

  @override
  State<RButton> createState() => _RButtonState();
}
class _RButtonState extends State<RButton>{
  bool isInside = false;
  bool isPressed = false;

  void onMouseEnter(){
    isInside = true;
  }

  void onMouseExit(){
    isInside = false;
    isPressed = false;
  }

  void onPointerDown(int pressedButton){
    if(widget.pressedStyleButtons.contains(pressedButton)){
      isPressed = true;
    }
  }

  void onPointerUp(){
    isPressed = false;
  }

  @override
  Widget build(BuildContext context){
    return MouseRegion(
      cursor: widget.usable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (PointerEnterEvent event){
        setState((){
          onMouseEnter();
        });
      },
      onExit: (PointerExitEvent event){
        setState((){
          onMouseExit();
        });
      },
      child: Listener(
        onPointerDown: (PointerDownEvent event){
          setState((){
            onPointerDown(event.buttons);
          });
        },
        onPointerUp: (PointerUpEvent event){
          setState((){
            onPointerUp();
          });
        },
        onPointerCancel: (PointerCancelEvent event){
          setState((){
            onPointerUp();
          });
        },
        child: Builder(
          builder: (BuildContext context){
            ContainerStyle actionStyle = (widget.usable ? widget.enabledStyle : widget.disabledStyle) ?? ContainerStyle.defaultStyle;

            if(widget.usable && isInside && widget.hoveredStyle != null){
              actionStyle = widget.hoveredStyle!;
            }

            if(widget.usable && isPressed && widget.pressedStyle != null){
              actionStyle = widget.pressedStyle!;
            }

            ContainerStyle style = widget.style == null ? actionStyle : ContainerStyle.merge(widget.style!, actionStyle);

            return AnimatedContainer(
              duration: widget.duration,
              curve: widget.curve,
              alignment:style.alignment,
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
              child: widget.builder == null ? widget.child : widget.builder!(context, widget.child, isInside, isPressed),
            );
          },
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget{
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;

  final double borderRadius;
  final ColorRoles colorRole;
  final bool transparent;
  final bool usable;
  final void Function()? onClick;
  final Widget? child;
  final Widget? Function(BuildContext context, Widget? child, bool isInside, bool isPressed)? builder;

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
    this.colorRole = ColorRoles.primary,
    bool? transparent,
    this.usable = true,
    this.onClick,
    this.child,
    this.builder,
  }) : transparent = transparent ?? colorRole == ColorRoles.background ? false : true;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: usable ? onClick : null,
      child: RButton(
        duration: duration,
        curve: curve,
        style: ContainerStyle(
          alignment: alignment,
          padding: padding,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
        ),
        enabledStyle: ContainerStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: transparent ? AppTheme.of(context)!.colorScheme.byRole(colorRole).enabledColor.withAlpha(0) : AppTheme.of(context)!.colorScheme.byRole(colorRole).enabledColor,
          ),
        ),
        disabledStyle: ContainerStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: transparent ? AppTheme.of(context)!.colorScheme.byRole(colorRole).disabledColor.withAlpha(0) : AppTheme.of(context)!.colorScheme.byRole(colorRole).disabledColor,
          ),
        ),
        hoveredStyle: ContainerStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: AppTheme.of(context)!.colorScheme.byRole(colorRole).hoveredColor,
          ),
        ),
        pressedStyle: ContainerStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: AppTheme.of(context)!.colorScheme.byRole(colorRole).pressedColor,
          ),
        ),
        usable: usable,
        builder: builder,
        child: child,
      ),
    );
  }
}


////////////////////
//     Switch     //
////////////////////

class RSwitch extends StatefulWidget{
  final Duration duration;
  final Curve curve;
  final ContainerStyle? offStyle;
  final ContainerStyle? onStyle;
  final ContainerStyle? hoveredStyle;
  final bool value;
  final bool usable;
  final Widget? child;
  final void Function(bool value)? onChange;
  final Widget? Function(BuildContext context, Widget? child, bool value)? builder;

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
class _RSwitchState extends State<RSwitch>{
  bool isInside = false;
  bool value = false;

  void onMouseEnter(){
    isInside = true;
  }

  void onMouseExit(){
    isInside = false;
  }

  void toggle(){
    value = !value;
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context){
    return MouseRegion(
      cursor: widget.usable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (PointerEnterEvent event){
        setState((){
          onMouseEnter();
        });
      },
      onExit: (PointerExitEvent event){
        setState((){
          onMouseExit();
        });
      },
      child: GestureDetector(
        onTap: (){
          setState((){
            toggle();
          });
        },
        child: Builder(
          builder: (BuildContext context){
            ContainerStyle style = (value ? widget.onStyle : widget.offStyle) ?? ContainerStyle.defaultStyle;
            ContainerStyle actionStyle = style;

            if(!value && widget.usable && isInside && widget.hoveredStyle != null){
              actionStyle = widget.hoveredStyle!;
            }

            style = ContainerStyle.merge(style, actionStyle);

            return AnimatedContainer(
              duration: widget.duration,
              curve: widget.curve,
              alignment:style.alignment,
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
              child: widget.builder == null ? widget.child : widget.builder!(context, widget.child, value),
            );
          },
        ),
      ),
    );
  }
}


class SmallSwitch extends StatelessWidget{
  final Duration duration;
  final Curve curve;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;

  final double borderRadius;
  final ColorRoles colorRole;
  final bool value;
  final bool usable;
  final void Function(bool value)? onChange;
  final Widget? child;
  final Widget? Function(BuildContext context, Widget? child, bool valued)? builder;

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
    this.colorRole = ColorRoles.primary,
    this.value = false,
    this.usable = true,
    this.onChange,
    this.child,
    this.builder,
  });

  @override
  Widget build(BuildContext context){
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
          color: AppTheme.of(context)!.colorScheme.byRole(colorRole).pressedColor,
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
          color: AppTheme.of(context)!.colorScheme.byRole(colorRole).hoveredColor,
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


class RTextFiled extends StatelessWidget{
  final TextEditingController? controller;
  final String? labelText;
  final ColorRoles colorRole;

  const RTextFiled({
    super.key,
    this.controller,
    this.labelText,
    this.colorRole = ColorRoles.primary,
  });

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      cursorColor: AppTheme.of(context)!.colorScheme.byRole(colorRole).onColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppTheme.of(context)!.colorScheme.byRole(colorRole).onColor,
        ),
        floatingLabelStyle: TextStyle(
          color: AppTheme.of(context)!.colorScheme.byRole(colorRole).onPressedColor,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.of(context)!.colorScheme.byRole(colorRole).onColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.of(context)!.colorScheme.byRole(colorRole).onColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: AppTheme.of(context)!.colorScheme.byRole(colorRole).pressedColor),
        ),
      ),
    );
  }
}