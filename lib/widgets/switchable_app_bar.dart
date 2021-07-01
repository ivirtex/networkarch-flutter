// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonActions {
  start,
  stop,
}

AppBar switchableAppBar({
  required BuildContext context,
  required String title,
  required ButtonActions action,
  VoidCallback? onPressed,
}) {
  return AppBar(
    title: Text(
      title,
    ),
    iconTheme: Theme.of(context).iconTheme,
    textTheme: Theme.of(context).textTheme,
    actions: [
      action == ButtonActions.start
          ? IconButton(
              splashRadius: 25.0,
              icon: FaIcon(
                FontAwesomeIcons.play,
                color: Colors.green,
              ),
              onPressed: onPressed,
            )
          : IconButton(
              splashRadius: 25.0,
              icon: FaIcon(
                FontAwesomeIcons.stopCircle,
                color: Colors.red,
              ),
              onPressed: onPressed,
            )
    ],
  );
}
