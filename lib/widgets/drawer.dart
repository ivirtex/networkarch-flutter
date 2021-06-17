// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'builders.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Builders.buildMenuListTile(
            icon: FaIcon(FontAwesomeIcons.cog),
            text: "Settings",
            onTap: () {
              // TODO: Implement onTap()
            },
          ),
          Builders.buildMenuListTile(
            icon: FaIcon(FontAwesomeIcons.infoCircle),
            text: "About",
            onTap: () {
              // TODO: Implement onTap()
            },
          ),
        ],
      ),
    );
  }
}
