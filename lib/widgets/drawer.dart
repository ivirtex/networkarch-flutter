// Flutter imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
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
              color: isDarkModeOn ? Colors.white : Colors.white,
            ),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.adjust,
              color: isDarkModeOn ? Colors.white : Colors.white,
            ),
            title: Text("Theme"),
            trailing: EasyDynamicThemeBtn(),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.infoCircle,
                  color: isDarkModeOn ? Colors.white : Colors.white,
                ),
                title: Text("About"),
                onTap: () {},
              ),
            ),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.bug,
              color: Colors.red,
            ),
            title: Text(
              "Report a bug",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
