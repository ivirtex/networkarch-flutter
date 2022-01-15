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
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return PlatformWidget(
      androidBuilder: (context) => const Scaffold(),
      iosBuilder: (context) => CupertinoPageScaffold(
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
          body: _buildBody(isDarkModeOn),
        ),
      ),
    );
  }

  ListView _buildBody(bool isDarkModeOn) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDarkModeOn ? Constants.darkBgColor : Constants.lightBgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: const Text('h'),
        ),
        const Divider(
          indent: 30,
          height: 1,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDarkModeOn ? Constants.darkBgColor : Constants.lightBgColor,
          ),
          child: const Text('h'),
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.adjust,
            color: isDarkModeOn ? Colors.white : Colors.black,
          ),
          title: const Text('Theme'),
          trailing: EasyDynamicThemeBtn(),
        ),
      ],
    );
  }
}
