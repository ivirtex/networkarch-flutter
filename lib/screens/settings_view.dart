// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  SingleChildScrollView _buildAndroid(BuildContext context) {
    return SingleChildScrollView(
      child: _buildBody(context),
    );
  }

  CupertinoPageScaffold _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text(
              'Settings',
            ),
          )
        ],
        body: _buildBody(context),
      ),
    );
  }

  RoundedList _buildBody(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return RoundedList(
      children: [
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.adjust,
            color: isDarkModeOn ? Colors.white : Colors.black,
          ),
          title: const Text('Theme'),
          trailing: EasyDynamicThemeBtn(),
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.language,
            color: isDarkModeOn ? Colors.white : Colors.black,
          ),
          title: const Text('Language'),
          trailing: const Text('English'),
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.infoCircle,
            color: isDarkModeOn ? Colors.white : Colors.black,
          ),
          title: const Text('About'),
          // onTap: () => Navigator.pushNamed(context, '/about'),
        ),
      ],
    );
  }
}
