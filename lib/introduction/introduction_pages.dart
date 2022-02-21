// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';

// Project imports:
import 'package:network_arch/permissions/permissions.dart';

final List<PageViewModel> pagesList = [
  PageViewModel(
    title: 'Welcome to NetworkArch',
    body: '',
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
