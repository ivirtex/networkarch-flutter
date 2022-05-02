// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';
import 'package:hive/hive.dart';

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

void showElegantNotification(
  BuildContext context,
  ElegantNotification notification,
) {
  notification.background = Theme.of(context).colorScheme.surfaceVariant;
  notification.showProgressIndicator = false;
  notification.radius = 10.0;

  notification.show(context);
}
