
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/game/uid.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";

import "package:flutter/material.dart";
import "dart:async";

import "package:easy_localization/easy_localization.dart";



class GameSelectorBuilder extends StatelessWidget{
  final List<LauncherChannel>? whitelist;
  final Widget Function(BuildContext context, Future<List<Game>> foundGameList, List<Game> customGameList) builder;

  const GameSelectorBuilder({
    super.key,
    this.whitelist,
    required this.builder,
  });

  List<Game> _filter(List<Game> raw){
    if(whitelist == null) return raw;

    return raw..removeWhere((Game game) => !whitelist!.contains(game.launcherChannel));
  }
  Future<List<Game>> _filterAsync(Future<List<Game>> raw) async{
    return _filter(await raw);
  }

  @override
  Widget build(BuildContext context){
    return builder(
      context,
      _filterAsync(FindGame.find()),
      _filter(AppState.customGame.value),
    );
  }

  /// sync
  static GameSelectorBuilder sync({
    Key? key,
    List<LauncherChannel>? whitelist,
    bool showIndicator = false,
    required Widget Function(BuildContext context, List<Game> gameList) builder,
  }){
    return GameSelectorBuilder(
      key: key,
      whitelist: whitelist,
      builder: (BuildContext context, Future<List<Game>> foundGameList, List<Game> customGameList){
        return RFutureBuilder(
          future: foundGameList,
          waitingBuilder: (BuildContext context, Widget indicator){
            return showIndicator ? indicator : block0;
          },
          errorBuilder: (BuildContext context){
            return builder(context, customGameList);
          },
          builder: (BuildContext context, List<Game> foundGameList){
            return builder(context, foundGameList + customGameList);
          },
        );
      },
    );
  }

  /// dynamic
  static GameSelectorBuilder dynamic({
    Key? key,
    List<LauncherChannel>? whitelist,
    required Widget Function(BuildContext context, List<Game> gameList) builder,
  }){
    return GameSelectorBuilder(
      key: key,
      whitelist: whitelist,
      builder: (BuildContext context, Future<List<Game>> foundGameList, List<Game> customGameList){
        return RFutureBuilder(
          future: foundGameList,
          waitingBuilder: (BuildContext context, Widget indicator){
            return builder(context, customGameList);
          },
          errorBuilder: (BuildContext context){
            return builder(context, customGameList);
          },
          builder: (BuildContext context, List<Game> foundGameList){
            return builder(context, foundGameList + customGameList);
          },
        );
      },
    );
  }
}

class UidSelectorBuilder extends StatelessWidget{
  final Game game;
  final Widget Function(BuildContext context, Future<List<Uid>> uidList) builder;

  const UidSelectorBuilder(
    this.game,
  {
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context){
    return builder(
      context,
      game.findUid(),
    );
  }

  /// sync
  static UidSelectorBuilder sync(
    Game game,
  {
    Key? key,
    bool showIndicator = false,
    required Widget Function(BuildContext context, List<Uid> uidList) builder,
  }){
    return UidSelectorBuilder(
      game,
      key: key,
      builder: (BuildContext context, Future<List<Uid>> uidList){
        return RFutureBuilder(
          future: uidList,
          waitingBuilder: (BuildContext context, Widget indicator){
            return showIndicator ? indicator : block0;
          },
          builder: (BuildContext context, List<Uid> uidList){
            return builder(context, uidList);
          },
        );
      },
    );
  }
}


// class AccountSelectorBuilder extends StatelessWidget{
//   final Game? game;
//   final List<LauncherChannel>? whitelist;
//   final bool isSelectUid;
//   final bool mustSelectUid;
//   final void Function(Game game, Uid? uid)? onSelected;
//   final Widget Function(BuildContext context, Widget gameBox) builder;
//   final Widget Function(BuildContext context, Game game, void Function() onSelected, Widget? uidBox) gameItemBuilder;
//   final Widget Function(BuildContext context, Uid uid, void Function() onSelected)? uidItemBuilder;
//   final Widget Function(BuildContext context, Future<List<Widget>> gameItems) gameBoxBuilder;
//   final Widget Function(BuildContext context, List<Widget> uidItems)? uidBoxBuilder;
//
//   const AccountSelectorBuilder({
//     super.key,
//     this.game,
//     this.whitelist,
//     this.isSelectUid = true,
//     bool mustSelectUid = false,
//     this.onSelected,
//     required this.builder,
//     required this.gameItemBuilder,
//     this.uidItemBuilder,
//     required this.gameBoxBuilder,
//     this.uidBoxBuilder,
//   }) :
//     mustSelectUid = game == null ? mustSelectUid : true,
//     assert(!(game != null && whitelist != null), "错误: game 与 whitelist 至少有一个为 null"),
//     assert(!(game != null && isSelectUid == false), "错误: game 不为 null 时, isSelectUid 必须为 true"),
//     assert(!(isSelectUid == false && mustSelectUid == true), "错误: mustSelectUid 为 true 时, isSelectUid 必须为 true"),
//     assert(!(isSelectUid == true && uidItemBuilder == null), "错误: isSelectUid 为 true 时, uidItemBuilder 不能为 null"),
//     assert(!(isSelectUid == true && uidBoxBuilder == null), "错误: isSelectUid 为 true 时, uidBoxBuilder 不能为 null")
//     ;
//
//   Future<List<Widget>> _createGameItem(BuildContext context, FutureOr<List<Game>> raw) async{
//     final List<Widget> res = [];
//
//     for(final Game game in await raw){
//       final List<Uid> uidList = await game.findUid();
//
//       if(uidList.isEmpty && isSelectUid) continue;
//
//       res.add(gameItemBuilder(context, game, (){
//
//       }, uidBoxBuilder?.call(
//         context,
//         _createUidItem(context, uidList),
//       )));
//     }
//
//     return res;
//   }
//
//   List<Widget> _createUidItem(BuildContext context, List<Uid> uidList){
//     if(uidItemBuilder == null) return [];
//     final List<Widget> res = [];
//
//     for(final Uid uid in uidList){
//       res.add(uidItemBuilder!(context, uid, (){
//
//       }));
//     }
//
//     return res;
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return builder(
//       context,
//       GameSelectorBuilder.dynamic(
//         whitelist: whitelist,
//         builder: (BuildContext context, List<Game> gameList){
//           return gameBoxBuilder(
//             context,
//             _createGameItem(context, gameList),
//           );
//         },
//       )
//     );
//   }
// }


class AccountSelector{
  final Game? game;
  final List<LauncherChannel>? whitelist;
  final bool isSelectUid;
  final bool mustSelectUid;
  final void Function(Game game, Uid? uid)? onSelected;
  final void Function()? onAdd;

  const AccountSelector({
    this.game,
    this.whitelist,
    this.isSelectUid = true,
    bool mustSelectUid = false,
    this.onSelected,
    this.onAdd,
  }) :
    mustSelectUid = game == null ? mustSelectUid : true,
    assert(!(game != null && whitelist != null), "错误: game 与 whitelist 至少有一个为 null"),
    assert(!(game != null && isSelectUid == false), "错误: game 不为 null 时, isSelectUid 必须为 true"),
    assert(!(isSelectUid == false && mustSelectUid == true), "错误: mustSelectUid 为 true 时, isSelectUid 必须为 true")
  ;

  Future<Map<Game, List<Uid>>> _filter(FutureOr<List<Game>> gameList) async{
    final Map<Game, List<Uid>> res = {};

    for(final Game game in await gameList){
      if(whitelist != null && !whitelist!.contains(game.launcherChannel)) continue;

      if(!isSelectUid){
        res[game] = <Uid>[];
        continue;
      }

      final List<Uid> uidList = await game.findUid();

      if(uidList.isEmpty && mustSelectUid) continue;

      res[game] = uidList;
    }

    return res;
  }

  Widget _itemButtonBuilder({required BuildContext context, ImageProvider? image, required String text}){
    return Row(
      spacing: listSpacing,
      children: [
        image == null ? block0 : Image(image: image, height: smallButtonSize - 10),
        Text(text, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, ColorRoles colorRole, Game game, List<Uid> uidList){
    if(uidList.isEmpty){
      return MenuItemButton(
        onPressed: (){
          onSelected?.call(game, null);
        },
        child: _itemButtonBuilder(context: context, image: game.logoImage, text: game.name),
      );
    }

    return SubmenuButton(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.byRole(colorRole).color),
      ),
      menuChildren: List.generate(
        uidList.length,
        (int index){
          final Uid uid = uidList[index];
          return MenuItemButton(
            onPressed: (){
              onSelected?.call(game, uid);
            },
            child: RFutureBuilder(
              future: uid.avatarImage,
              waitingBuilder: (BuildContext context, Widget indicator){
                return _itemButtonBuilder(context: context, text: uid.name);
              },
              builder: (BuildContext context, avatar){
                return _itemButtonBuilder(context: context, image: avatar == null ? null : FileImage(avatar.file), text: uid.name);
              },
            ),
          );
        }
      ),
      child: _itemButtonBuilder(context: context, image: game.logoImage, text: game.name),
    );
  }

  List<Widget> _menuChildrenBuilder(BuildContext context, ColorRoles colorRole){
    final List<Widget> menuChildren = <Widget>[];

    /// find Game from device
    menuChildren.add(
      RFutureBuilder<Map<Game, List<Uid>>>(
        future: _filter(FindGame.find()),
        builder: (BuildContext context, Map<Game, List<Uid>> games){
          final List<MapEntry<Game, List<Uid>>> gameEntries = games.entries.toList();

          return Column(
            children: List.generate(
              gameEntries.length,
              (int index) => _itemBuilder(context, colorRole, gameEntries[index].key, gameEntries[index].value),
            ),
          );
        }
      ),
    );

    /// user's custom Game
    menuChildren.add(
      RFutureBuilder<Map<Game, List<Uid>>>(
        future: _filter(AppState.customGame.value),
        builder: (BuildContext context, Map<Game, List<Uid>> games){
          final List<MapEntry<Game, List<Uid>>> gameEntries = games.entries.toList();

          return Column(
            children: List.generate(
              gameEntries.length,
              (int index) => _itemBuilder(context, colorRole, gameEntries[index].key, gameEntries[index].value),
            ),
          );
        }
      ),
    );

    /// the last is "add" button, user can add custom Game
    if(onAdd != null){
      menuChildren.add(
        MenuItemButton(
          onPressed: onAdd,
          child: Text(context.tr("addCustomAccountButton"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.byRole(colorRole).onColor)),
        ),
      );
    }

    return menuChildren;
  }


  Widget menuAnchor({
    required BuildContext context,
    ColorRoles colorRole = ColorRoles.background,
    required Widget Function(BuildContext, MenuController, Widget?) builder,
  }){
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.byRole(colorRole).color),
      ),
      builder: builder,
      menuChildren: _menuChildrenBuilder(context, colorRole),
    );
  }

  Widget submenuButton({
    required BuildContext context,
    ColorRoles colorRole = ColorRoles.background,
    required Widget? child,
  }){
    return SubmenuButton(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.byRole(colorRole).color),
      ),
      menuChildren: _menuChildrenBuilder(context, colorRole),
      child: child,
    );
  }
}









