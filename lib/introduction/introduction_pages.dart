// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/permissions/permissions.dart';

final List<PageViewModel> pagesList = [
  PageViewModel(
    title: 'Welcome to NetworkArch!',
    image: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      child: SizedBox(
        height: 300,
        child: Image.asset('assets/icon_alpha.png'),
      ),
    ),
    body: Constants.appDesc,
    decoration: const PageDecoration(
      bodyAlignment: Alignment.center,
    ),
  ),
  PageViewModel(
    title: 'Permissions',
    decoration: const PageDecoration(
      contentMargin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
    ),
    bodyWidget: const PermissionsView(),
    footer: TextButton(
      child: const Text('Open app settings'),
      onPressed: () {
        openAppSettings();
      },
    ),
  ),
];
