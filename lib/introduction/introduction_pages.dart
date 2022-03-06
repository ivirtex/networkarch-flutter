// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/permissions/permissions.dart';

final List<PageViewModel> pagesList = [
  PageViewModel(
    title: 'Welcome to NetworkArch!',
    image: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: SizedBox(
        height: 250,
        child: Builder(
          builder: (context) {
            final isDarkModeOn =
                Theme.of(context).brightness == Brightness.dark;

            return isDarkModeOn
                ? Image.asset('assets/icon_alpha_dark.png')
                : Image.asset('assets/icon_alpha_light.png');
          },
        ),
      ),
    ),
    bodyWidget: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: const [
          Text(
            Constants.appDesc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: Constants.listSpacing),
          OnboardingFeature(
            icon: Icons.wifi_rounded,
            title: 'WiFi',
            description:
                'Explore detailed information about your Wi-Fi network',
          ),
          SizedBox(height: Constants.listSpacing),
          OnboardingFeature(
            icon: Icons.cell_tower_rounded,
            title: 'Carrier',
            description:
                'Explore detailed information about your cellular network',
          ),
          SizedBox(height: Constants.listSpacing),
          OnboardingFeature(
            icon: Icons.settings_rounded,
            title: 'WiFi',
            description:
                'Test your networks thanks to various diagnostic tools such as ping, Wake on LAN, LAN Scanner and more',
          ),
        ],
      ),
    ),
  ),
  PageViewModel(
    title: 'Permissions',
    decoration: const PageDecoration(
      contentMargin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
    ),
    bodyWidget: const PermissionsView(),
    footer: Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        child: const Text('Open app settings'),
        onPressed: () {
          openAppSettings();
        },
      ),
    ),
  ),
];
