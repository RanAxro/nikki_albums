
import "package:flutter/widgets.dart";

import "package:forui/forui.dart";

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return FTileGroup.merge(
      label: const Text('Settings'),
      children: [
            .group(
          children: [
                .tile(
              prefix: const Icon(FLucideIcons.user),
              title: const Text('Personalization'),
              suffix: const Icon(FLucideIcons.chevronRight),
              onPress: () {},
            ),
                .tile(
              prefix: const Icon(FLucideIcons.wifi),
              title: const Text('WiFi'),
              details: const Text('Duobase (5G)'),
              suffix: const Icon(FLucideIcons.chevronRight),
              onPress: () {},
            ),
          ],
        ),
            .selectGroup(
          control: const .managedRadio(initial: 'List'),
          children: const [
            FSelectTile(title: Text('List View'), value: 'List'),
            FSelectTile(title: Text('Grid View'), value: 'Grid'),
          ],
        ),
      ],
    );
  }
}