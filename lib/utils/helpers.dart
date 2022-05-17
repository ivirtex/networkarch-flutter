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
  notification.background = Theme.of(context).colorScheme.surfaceVariant;
  notification.showProgressIndicator = false;
  notification.radius = 10.0;

  notification.show(context);
}
