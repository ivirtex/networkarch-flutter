// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/permissions/permissions.dart';

final List<PageViewModel> pagesList = [
  PageViewModel(
    title: 'Welcome to NetworkArch!',
    image: SafeArea(
      child: Builder(
        builder: (context) {
          final isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

          return isDarkModeOn
              ? SvgPicture.asset(
                  'assets/icons/icon_alpha_dark.svg',
                  semanticsLabel: 'NetworkArch logo',
                )
              : SvgPicture.asset(
                  'assets/icons/icon_alpha_light.svg',
                  semanticsLabel: 'NetworkArch logo',
                );
        },
      ),
    ),
    decoration: const PageDecoration(
      imagePadding: EdgeInsets.only(top: 40, bottom: 10),
      bodyFlex: 3,
    ),
    bodyWidget: Column(
      children: const [
        Text(
          Constants.appDesc,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: Constants.listSpacing),
        OnboardingFeature(
          icon: Icons.wifi_rounded,
          iosIcon: CupertinoIcons.wifi,
          title: 'Wi-Fi',
          description: 'Explore detailed information about your Wi-Fi network',
        ),
        SizedBox(height: Constants.listSpacing),
        OnboardingFeature(
          icon: Icons.cell_tower_rounded,
          iosIcon: CupertinoIcons.antenna_radiowaves_left_right,
          title: 'Carrier',
          description:
              'Explore detailed information about your cellular network',
        ),
        SizedBox(height: Constants.listSpacing),
        OnboardingFeature(
          icon: Icons.settings_rounded,
          iosIcon: CupertinoIcons.settings,
          title: 'Utilities',
          description:
              'Test your networks thanks to various diagnostic tools such as ping, Wake on LAN, LAN Scanner and more',
        ),
      ],
    ),
  ),
  PageViewModel(
    titleWidget: SafeArea(
      child: Builder(
        builder: (context) {
          return Text(
            'Permissions',
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    ),
    useScrollView: false,
    decoration: const PageDecoration(
      titlePadding: EdgeInsets.symmetric(vertical: 16),
      contentMargin: EdgeInsets.symmetric(
        horizontal: 8,
      ),
    ),
    bodyWidget: const Expanded(
      child: PermissionsView(),
    ),
    footer: const Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        onPressed: openAppSettings,
        child: Text('Open app settings'),
      ),
    ),
  ),
];
