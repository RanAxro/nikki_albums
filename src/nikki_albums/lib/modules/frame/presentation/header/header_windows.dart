
import "../../domain/state.dart";
import "../../domain/window_controller.dart";
import "package:nikki_albums/gen/app_icons.dart";

import "package:flutter/widgets.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:forui/forui.dart";
import "package:window_manager/window_manager.dart";


const double titleBarHeight = 46;
const double titleBarButtonHeight = 36;

class WindowsTitleBar extends StatelessWidget{
  const WindowsTitleBar({super.key});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: titleBarHeight,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DragToMoveArea(
              child: SizedBox(),
            ),
          ),

          Row(
            children: [
              IgnorePointer(
                ignoring: true,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: 50,
                  height: titleBarHeight,
                  child: Image.asset("assets/logo/nikkialbums.webp"),
                ),
              ),

              const Expanded(child: SizedBox()),

              const TopWindowButton(),

              WindowControlsButton(
                onPress: (){
                  minimize();
                },
                child: const SizedBox(
                  width: titleBarHeight + 10,
                  height: titleBarHeight,
                  child: Icon(AppIcons.minimize, size: 16),
                ),
              ),
              WindowControlsButton(
                onPress: (){
                  maximizeOrRestore();
                },
                child: const SizedBox(
                  width: titleBarHeight + 10,
                  height: titleBarHeight,
                  child: Icon(AppIcons.maximizeOrRestore, size: 16),
                ),
              ),
              WindowControlsButton(
                isDestructive: true,
                onPress: () {},
                child: const SizedBox(
                  width: titleBarHeight + 10,
                  height: titleBarHeight,
                  child: Icon(AppIcons.cross, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopWindowButton extends ConsumerWidget{
  const TopWindowButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final bool state = ref.watch(topWindowProvider);

    return SizedBox(
      width: titleBarButtonHeight,
      height: titleBarButtonHeight,
      child: FTooltip(
        tipBuilder: (BuildContext context, FTooltipController controller){
          return Text(state ? "取消置顶窗口" : "置顶窗口");
        },
        child: FButton(
          selected: state,
          variant: FButtonVariant.secondary,
          onPress: () async{
            await top(!state);
            ref.read(topWindowProvider.notifier).toggle();
          },
          child: const Icon(AppIcons.top, size: 16),
        ),
      ),
    );
  }
}

class WindowControlsButton extends StatelessWidget{
  final void Function()? onPress;
  final bool isDestructive;
  final Widget child;

  const WindowControlsButton({
    super.key,
    this.onPress,
    this.isDestructive = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return FTappable(
      style: const FTappableStyleDelta.delta(
        pressedEnterDuration: Duration(milliseconds: 0),
        pressedExitDuration: Duration(milliseconds: 0),
        motion: FTappableMotion.none,
      ),
      builder: (context, states, child){
        Color? color;

        if(states.contains(FTappableVariant.hovered) || states.contains(FTappableVariant.pressed)){
          if(isDestructive){
            color = context.theme.colors.destructive;
          }else{
            color = context.theme.colors.barrier;
          }
          if(!states.contains(FTappableVariant.pressed)){
            color = color.withValues(alpha: color.a * 0.5);
          }
        }

        return Container(
          color: color,
          child: child,
        );
      },
      onPress: onPress,
      child: child,
    );
  }
}