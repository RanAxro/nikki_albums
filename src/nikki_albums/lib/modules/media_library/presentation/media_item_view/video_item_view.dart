
import "dart:ui" as ui;

import "media_item_view.dart";
import "../../domain/item.dart";
import "package:nikki_albums/ui/common/common.dart";

import "package:flutter/widgets.dart";
import "dart:io";

import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:video_player/video_player.dart";
import "package:forui/forui.dart";


class VideoItemView<T extends MediaItem> extends MediaItemView<T>{
  const VideoItemView({
    super.key,
    required super.item,
    super.heroTag,
    super.thumbnail,
  });

  @override
  Widget buildMedia(BuildContext context, WidgetRef ref, T item){
    return FutureBuilder<FileSystemEntity>(
      future: item.native(),
      builder: (BuildContext context, AsyncSnapshot<FileSystemEntity> snapshot){
        if(snapshot.data == null){
          return nil;
        }
        return HookBuilder(
          builder: (BuildContext context){
            final VideoPlayerController controller = useMemoized(
              () => VideoPlayerController.file(snapshot.data! as File),
              <Object?>[snapshot.data!.path],
            );

            final Future<void> initializationFuture = useMemoized(() => controller.initialize(), <Object?>[controller]);
            final AsyncSnapshot<void> initializationSnapshot = useFuture(initializationFuture);

            useEffect((){
              return () => controller.dispose();
            }, <Object?>[controller]);

            if(!controller.value.isInitialized || initializationSnapshot.connectionState == ConnectionState.none || initializationSnapshot.connectionState == ConnectionState.waiting){
              return FCircularProgress();
            }
            if(initializationSnapshot.hasError){
              return Text(initializationSnapshot.error.toString());
            }
            return Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  alignment: .bottomCenter,
                  children: <Widget>[
                    VideoPlayer(controller),

                    SizedBox(
                      height: 46,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: ColoredBox(
                            color: context.theme.colors.background.withAlpha(150),
                            child: VideoItemViewPanel(controller: controller),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VideoItemViewPanel extends HookConsumerWidget{
  final VideoPlayerController controller;

  const VideoItemViewPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child){
        if(!controller.value.isInitialized){
          return nil;
        }

        return Padding(
          padding: .symmetric(horizontal: 6),
          child: Row(
            spacing: 8,
            children: <Widget>[
              FButton.icon(
                variant: .ghost,
                onPress: (){
                  if(controller.value.isPlaying){
                    controller.pause();
                  }else{
                    controller.play();
                  }
                },
                child: Icon(controller.value.isPlaying ? FLucideIcons.pause : FLucideIcons.play),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 150),
                child: Text("${_formatDuration(controller.value.position)} / ${_formatDuration(controller.value.duration)}"),
              ),

              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: controller.value.position.inMilliseconds.toDouble(),
                    end: controller.value.position.inMilliseconds.toDouble(),
                  ),
                  duration: const Duration(milliseconds: 100),
                  builder: (BuildContext context, double position, Widget? child){
                    return FSlider(
                      style: .delta(
                        childPadding: .value(.all(0)),
                      ),
                      control: FSliderControl.liftedContinuous(
                        value: FSliderValue(
                          max: position / controller.value.duration.inMilliseconds,
                          min: 0,
                        ),
                        onChange: (FSliderValue value){
                          final double ms = value.max * controller.value.duration.inMilliseconds;
                          controller.seekTo(Duration(milliseconds: ms.toInt()));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration){
    final StringBuffer buffer = StringBuffer();
    final int hours = duration.inHours;
    if(hours > 0){
      buffer.write(hours);
      buffer.write(":");
    }
    buffer.write((duration.inMinutes - hours * 60).toString().padLeft(2, "0"));
    buffer.write(":");
    buffer.write((duration.inSeconds - duration.inMinutes * 60).toString().padLeft(2, "0"));
    buffer.write(":");
    buffer.write(((duration.inMilliseconds - duration.inSeconds * 1000) ~/ 10).toString().padLeft(2, "0"));
    return buffer.toString();
  }
}
