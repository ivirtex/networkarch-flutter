import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class Builders {
  static Row buildConnectionState(bool isNetworkConnected) {
    return Row(
      children: [
        Text(
          isNetworkConnected ? "Connected" : "Not connected",
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
      {FaIcon icon, String text, Function onTap}) {
    return ListTile(
      title: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Text(text),
        ],
      ),
      onTap: onTap,
    );
  }
}
