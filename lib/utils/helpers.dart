// Package imports:
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
