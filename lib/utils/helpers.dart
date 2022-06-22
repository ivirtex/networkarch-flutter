// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:network_arch/constants.dart';

bool isPremiumActive() {
  final iapBox = Hive.box('iap');

  return iapBox.get(
        'isPremiumGranted',
        defaultValue: false,
      ) as bool ||
      iapBox.get(
        'isPremiumTempGranted',
        defaultValue: false,
      ) as bool;
}

String getAdUnitId() {
  return kReleaseMode
      ? Platform.isIOS
          ? Constants.overviewIOSAdUnitId
          : Constants.overviewAndroidAdUnitId
      : Constants.testBannerAdUnitId;
}

void showElegantNotification(
  BuildContext context,
  ElegantNotification notification,
) {
  // notification.background = Themes.iOSCardColor.resolveFrom(context);
  notification.showProgressIndicator = false;
  notification.radius = 10.0;

  notification.show(context);
}

void hideKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

void showPlatformMessage(
  BuildContext context, {
  required SnackBar androidMessage,
  required ElegantNotification iOSmessage,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    showElegantNotification(context, iOSmessage);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(androidMessage);
  }
}
