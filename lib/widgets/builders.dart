// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class Builders {
  static Row buildConnectionState(bool isNetworkConnected) {
    return Row(
      children: [
        Text(
          isNetworkConnected ? "Connected" : "Disconnected",
          style: TextStyle(
            color: isNetworkConnected ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10.0),
        FaIcon(
          isNetworkConnected
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.timesCircle,
          color: isNetworkConnected ? Colors.green : Colors.red,
        )
      ],
    );
  }

  static ListTile buildMenuListTile(
      {FaIcon? icon, required String text, Function? onTap}) {
    return ListTile(
      title: Row(
        children: [
          icon!,
          SizedBox(width: 10),
          Text(text),
        ],
      ),
      onTap: onTap as void Function()?,
    );
  }
}
