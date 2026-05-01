import "frame.dart";

import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

class AndroidFrame extends StatelessWidget {
  const AndroidFrame({super.key});

  @override
  Widget build(BuildContext context) {
    // requestAllFilesAccess();

    return ColoredBox(
      color: AppTheme.of(context)!.colorScheme.background.color,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: androidTitleBarHeight, child: AndroidTitleBar()),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // te();
                },
                child: Container(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AndroidTitleBar extends StatelessWidget {
  const AndroidTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: topBarHeight,
      color: AppTheme.of(context)!.colorScheme.secondary.color,
      child: Row(children: [const AccountButton()]),
    );
  }
}
