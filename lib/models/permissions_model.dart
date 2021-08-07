// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionsModel extends ChangeNotifier {
  // PERMISSIONS:
  // ACCESS_FINE_LOCATION
  // requestLocationServiceAuthorization
  // Access WiFi information capability in XCode must be enabled.

  SharedPreferences? prefs;

  PermissionWithService locationPermission = Permission.location;
  bool isLocationPermissionGranted = false;
  FaIcon locationStatusIcon = const FaIcon(
    FontAwesomeIcons.timesCircle,
    color: Colors.red,
    size: 30,
  );

  void setLocationStatusIcon(PermissionStatus status) {
    if (status == PermissionStatus.granted) {
      locationStatusIcon = const FaIcon(
        FontAwesomeIcons.check,
        color: Colors.green,
        size: 30,
      );

      isLocationPermissionGranted = true;
    } else if (status == PermissionStatus.denied) {
      locationStatusIcon = const FaIcon(
        FontAwesomeIcons.timesCircle,
        color: Colors.red,
        size: 30,
      );
    }

    notifyListeners();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
