// Flutter imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'shared_widgets.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
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
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.cog,
              color: Colors.black,
            ),
            title: Text("Settings"),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.infoCircle,
              color: Colors.black,
            ),
            title: Text("About"),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.adjust,
              color: Colors.black,
            ),
            title: Text("Theme"),
            trailing: EasyDynamicThemeBtn(),
          )
        ],
      ),
    );
  }
}
