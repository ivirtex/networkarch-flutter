// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
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
              color: isDarkModeOn ? Colors.white : Colors.black,
            ),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.adjust,
              color: isDarkModeOn ? Colors.white : Colors.black,
            ),
            title: const Text('Theme'),
            trailing: EasyDynamicThemeBtn(),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.infoCircle,
                  color: isDarkModeOn ? Colors.white : Colors.black,
                ),
                title: const Text('About'),
                onTap: () {},
              ),
            ),
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.bug,
              color: Colors.red,
            ),
            title: const Text(
              'Report a bug',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
