// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CupertinoActionAppBar extends StatelessWidget {
  const CupertinoActionAppBar(
    this.context, {
    required this.title,
    required this.action,
    required this.isActive,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final ButtonAction action;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      stretch: true,
      border: null,
      largeTitle: Text(title),
      trailing: action == ButtonAction.start
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? onPressed : null,
              child: const Icon(
                CupertinoIcons.play_arrow_solid,
                color: CupertinoColors.activeGreen,
              ),
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? onPressed : null,
              child: const FaIcon(
                CupertinoIcons.stop_fill,
                color: CupertinoColors.destructiveRed,
              ),
            ),
    );
  }
}

enum ButtonAction {
  start,
  stop,
}
