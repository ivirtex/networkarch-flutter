// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonActions {
  start,
  stop,
}

abstract class Builders {
  static AppBar switchableAppBar({
    required BuildContext context,
    required String title,
    required ButtonActions action,
    required bool isActive,
    VoidCallback? onPressed,
  }) {
    return AppBar(
      title: Text(
        title,
      ),
      iconTheme: Theme.of(context).iconTheme,
      titleTextStyle: Theme.of(context).textTheme.headline6,
      actions: [
        if (action == ButtonActions.start)
          IconButton(
            splashRadius: 25.0,
            icon: FaIcon(
              FontAwesomeIcons.play,
              color: isActive ? Colors.green : Colors.grey,
            ),
            onPressed: isActive ? onPressed : null,
          )
        else
          IconButton(
            splashRadius: 25.0,
            icon: FaIcon(
              FontAwesomeIcons.stopCircle,
              color: isActive ? Colors.red : Colors.grey,
            ),
            onPressed: isActive ? onPressed : null,
          )
      ],
    );
  }

  static CupertinoSliverNavigationBar switchableCupertinoNavigationBar({
    required BuildContext context,
    required String title,
    required ButtonActions action,
    required bool isActive,
    VoidCallback? onPressed,
  }) {
    return CupertinoSliverNavigationBar(
      stretch: true,
      border: null,
      largeTitle: Text(
        title,
      ),
      trailing: action == ButtonActions.start
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? onPressed : null,
              child: const Icon(
                CupertinoIcons.play,
                color: CupertinoColors.activeGreen,
              ),
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? onPressed : null,
              child: const FaIcon(
                CupertinoIcons.stop,
                color: CupertinoColors.destructiveRed,
              ),
            ),
    );
  }
}
