import "package:nikkialbums/info.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/Image.dart";
import "package:nikkialbums/api/system/system.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";


final ContentItem item = ContentItem(
  expectedPosition: 3,
  name: "resource",
  icon: AssetImage("assets/icon/resource.webp"),
  page: Resource(),
);

void init(){
  pages.addItem(item);
}


class Resource extends StatelessWidget{
  static Future<Path?> getPath(ResourceType type) async{
    final ResourceInfoItem info = resourcesInfoMap[type]!;

    if(info.onlyWindows){
      if(Platform.isWindows){
        final String username = await getWindowsUserName();
        return Path(info.locate.replaceAll(r"$username$", username));
      }
    }

    if(info.isRequireInstall){
      if(AppState.currentGame.value?.installPath != null){
        final Path installPath = AppState.currentGame.value!.installPath!;
        return installPath + info.locate;
      }
    }
    return null;
  }

  final ValueNotifier<ResourceType> resourceType = ValueNotifier(ResourceType.LauncherCacheImages);
  Resource({super.key});

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: topBarHeight,
          child: Container(
            alignment: Alignment.centerLeft,
            child: ResourceButton(resourceType: resourceType),
          ),
        ),
        Positioned(
          left: 0,
          top: topBarHeight,
          right: 0,
          bottom: 0,
          child: ResourceViewer(resourceType: resourceType),
        )
      ],
    );
  }
}


class ResourceButton extends StatelessWidget{
  final ValueNotifier<ResourceType> resourceType;

  const ResourceButton({
    super.key,
    required this.resourceType,
  });

  Future<void> _openResourceFolder(ResourceType type) async{
    (await Resource.getPath(type))?.open();
  }

  @override
  Widget build(BuildContext context){

    final List<Widget> menuChildren = <Widget>[];

    for(ResourceType type in resourcesInfoMap.keys){
      final ResourceInfoItem info = resourcesInfoMap[type]!;
      menuChildren.add(MenuItemButton(
        onPressed: (){
          resourceType.value = type;
        },
        child: Text(context.tr(info.name), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
      ));
    }

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        final Widget text = ValueListenableBuilder(
          valueListenable: resourceType,
          builder: (BuildContext context, ResourceType type, Widget? child){
            return Text(context.tr(resourcesInfoMap[type]!.name), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor));
          },
        );

        return GestureDetector(
          onSecondaryTap: (){
            _openResourceFolder(resourceType.value);
          },
          child: SmallButton(
            padding: const EdgeInsets.all(6),
            width: null,
            colorRole: ColorRoles.secondary,
            onClick: (){
              controller.isOpen ? controller.close() : controller.open();
            },
            child: text,
          ),
        );
      },
      menuChildren: menuChildren,
    );
  }
}




class ResourceViewer extends StatelessWidget{
  final ValueNotifier<ResourceType> resourceType;
  const ResourceViewer({
    super.key,
    required this.resourceType,
  });

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: resourceType,
      builder: (BuildContext context, ResourceType type, Widget? child){
        if(type == ResourceType.Movies){
          return RFutureBuilder(
            future: Future(() async{
              final Path? path = await Resource.getPath(resourceType.value);
              if(path == null) return null;

              final List<Path> res = <Path>[];

              try{
                final list = await path.directory.list(recursive: true).toList();

                for(final item in list){
                  final Path path = Path(item.path);
                  if(FileSystemEntityType.file == await path.typeAsync){
                    res.add(path);
                  }
                }

                return res;
              }catch(e){
                return null;
              }
            }),
            builder: (BuildContext context, List<Path>? movies){
              if(movies == null) return block0;

              return ListViewer(movies: movies);
            },
          );
        }
        return RFutureBuilder(
          future: Future(() async{
            final Path? path = await Resource.getPath(resourceType.value);
            if(path == null) return null;

            final List<Path> res = <Path>[];

            try{
              final list = await path.directory.list(recursive: true).toList();

              for(final item in list){
                final Path path = Path(item.path);
                if(isImageExtension(path) && FileSystemEntityType.file == await path.typeAsync){
                  res.add(path);
                }
              }

              return res;
            }catch(e){
              return null;
            }
          }),
          builder: (BuildContext context, List<Path>? images){
            if(images == null) return block0;

            return GridViewer(images: images);
          },
        );
      },
    );
  }
}




class GridViewer extends StatelessWidget{
  final List<Path> images;
  const GridViewer({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder<int>(
      valueListenable: AppState.albumColumn,
      builder: (BuildContext context, int column, Widget? child){
        return SmoothPointerScroll(
          builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: column,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1,
              ),
              itemCount: images.length,
              controller: controller,
              physics: physics,
              itemBuilder: (context, index){
                return KeepAliveWrapper(
                  child: Exhibit(images, images[index]),
                );
              },
            );
          },
        );
      }
    );
  }
}




class ListViewer extends StatelessWidget{
  final List<Path> movies;
  const ListViewer({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context){
    return SmoothPointerScroll(
      builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
        return ListView.builder(
          itemCount: movies.length,
          controller: controller,
          physics: physics,
          itemBuilder: (context, index){
            return KeepAliveWrapper(
              child: SmallButton(
                colorRole: ColorRoles.background,
                onClick: (){
                  playBk2VideoInWindows(movies[index]);
                },
                child: Row(
                  children: [
                    Image.asset("assets/icon/run.webp", height: 30, color: AppTheme.of(context)!.colorScheme.background.onColor),
                    Text(movies[index].name, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
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




class Exhibit extends StatefulWidget{
  final List<Path> images;
  final Path currentImage;
  const Exhibit(
    this.images,
    this.currentImage,
    {super.key}
  );

  @override
  State<Exhibit> createState() => _ExhibitState();
}
class _ExhibitState extends State<Exhibit>{
  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: ImageThumbnail.fromCache(id: widget.currentImage.name, imagePath: widget.currentImage, targetWidth: 720),
      builder: (context, image){

        return GestureDetector(
          onSecondaryTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(smallBorderRadius),
                  ),
                  backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
                  child: ImageViewer(
                    imageCount: widget.images.length,
                    initIndex: widget.images.indexOf(widget.currentImage),
                    imageBuilder: (BuildContext context, int index){
                      return Image.file(widget.images[index].file, fit: BoxFit.contain);
                    },
                  ),
                );
              }
            );
          },
          child: RawImage(
            image: image,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}