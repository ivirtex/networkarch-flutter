// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonActions {
  start,
  stop,
}

abstract class Builders {
  static Row buildConnectionState({required bool isNetworkConnected}) {
    return Row(
      children: [
        Text(
          isNetworkConnected ? 'Connected' : 'Disconnected',
          style: TextStyle(
            color: isNetworkConnected ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10.0),
        FaIcon(
          isNetworkConnected
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.timesCircle,
          color: isNetworkConnected ? Colors.green : Colors.red,
        )
      ],
    );
  }

  static AppBar switchableAppBar({
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
        if (action == ButtonActions.start)
          IconButton(
            splashRadius: 25.0,
            icon: const FaIcon(
              FontAwesomeIcons.play,
              color: Colors.green,
            ),
            onPressed: onPressed,
          )
        else
          IconButton(
            splashRadius: 25.0,
            icon: const FaIcon(
              FontAwesomeIcons.stopCircle,
              color: Colors.red,
            ),
            onPressed: onPressed,
          )
      ],
    );
  }
}
