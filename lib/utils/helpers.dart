// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/permissions/permissions.dart';

bool isPremiumActive() {
  final iapBox = Hive.box<bool>('iap');

  return iapBox.get(
        'isPremiumGranted',
        defaultValue: false,
      )! ||
      iapBox.get(
        'isPremiumTempGranted',
        defaultValue: false,
      )!;
}

String getAdUnitId() {
  return kReleaseMode
      ? Platform.isIOS
          ? Constants.overviewIOSAdUnitId
          : Constants.overviewAndroidAdUnitId
      : Constants.testBannerAdUnitId;
}

void hideKeyboard(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

void showPlatformMessage(
  BuildContext context, {
  required MessageType type,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  switch (type) {
    case MessageType.granted:
      isIOS
          ? showCupertinoDialog<void>(
              context: context,
              builder: Constants.permissionGrantedCupertinoDialog,
            )
          : ScaffoldMessenger.of(context).showSnackBar(
              Constants.permissionGrantedSnackbar,
            );
    case MessageType.denied:
      isIOS
          ? showCupertinoDialog<void>(
              context: context,
              builder: Constants.permissionDeniedCupertinoDialog,
            )
          : ScaffoldMessenger.of(context).showSnackBar(
              Constants.permissionDeniedSnackbar,
            );
    case MessageType.default_:
      isIOS
          ? showCupertinoDialog<void>(
              context: context,
              builder: Constants.permissionDefaultCupertinoDialog,
            )
          : ScaffoldMessenger.of(context).showSnackBar(
              Constants.permissionDefaultSnackbar,
            );
  }

  // if (Theme.of(context).platform == TargetPlatform.iOS) {
  //   showElegantNotification(context, iOSmessage);
  // } else {
  //   ScaffoldMessenger.of(context).showSnackBar(androidMessage);
  // }
}
