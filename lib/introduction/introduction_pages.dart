// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/permissions/permissions.dart';

final List<PageViewModel> pagesList = [
  PageViewModel(
    title: 'Welcome to NetworkArch!',
    image: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      child: SizedBox(
        height: 250,
        child: Image.asset('assets/icon.png'),
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
  ),
];
