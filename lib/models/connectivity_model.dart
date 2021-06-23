// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter/services.dart';
import 'package:sim_info/sim_info.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectivityModel {
  Future<SynchronousWifiInfo> getDataForIOS() async {
    // Await for all class values before yielding them
    var data = await Future.wait(
      [
        NetworkInfo().getLocationServiceAuthorization(), // 0
        NetworkInfo().requestLocationServiceAuthorization(), // 1
        NetworkInfo().getWifiBSSID(), // 2
        NetworkInfo().getWifiIP(), // 3
        NetworkInfo().getWifiName(), // 4
      ],
    );

    return SynchronousWifiInfo(
      locationServiceAuthorizationStatus: data[0],
      locationServiceAuthorization: data[1],
      wifiBSSID: data[2],
      wifiIP: data[3],
      wifiName: data[4],
    );
  }

  Future<SynchronousWifiInfo> getDataForAndroid() async {
    // Await for all class values before yielding them
    var data = await Future.wait(
      [
        NetworkInfo().getWifiBSSID(), // 0
        NetworkInfo().getWifiIP(), // 1
        NetworkInfo().getWifiName(), // 2
      ],
    );

    return SynchronousWifiInfo(
      locationServiceAuthorizationStatus: null,
      locationServiceAuthorization: null,
      wifiBSSID: data[0],
      wifiIP: data[1],
      wifiName: data[2],
    );
  }

  Stream<SynchronousWifiInfo> _wifiInfoStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));

      SynchronousWifiInfo wifiInfo;

      try {
        wifiInfo = await getDataForIOS();
      } on MissingPluginException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await getDataForAndroid();
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await getDataForAndroid();
      }

      yield wifiInfo;
    }
  }

  Stream<SynchronousCarrierInfo> _cellularInfoStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));

      SynchronousCarrierInfo carrierInfo;

      try {
        var data = await Future.wait(
          [
            SimInfo.getAllowsVOIP,
            SimInfo.getCarrierName,
            SimInfo.getIsoCountryCode,
            SimInfo.getMobileCountryCode,
            SimInfo.getMobileNetworkCode
          ],
        );

        carrierInfo = SynchronousCarrierInfo(
          allowsVOIP: data[0],
          carrierName: data[1],
          isoCountryCode: data[2],
          mobileCountryCode: data[3],
          mobileNetworkCode: data[4],
        );
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        throw Exception("SIM_CARD_NOT_READY");
      }

      yield carrierInfo;
    }
  }

  Stream<SynchronousWifiInfo> get getWifiInfoStream {
    return _wifiInfoStream();
  }

  Stream<SynchronousCarrierInfo> get getCellularInfoStream {
    return _cellularInfoStream();
  }
}

class SynchronousWifiInfo {
  SynchronousWifiInfo({
    this.locationServiceAuthorizationStatus,
    this.locationServiceAuthorization,
    this.wifiBSSID,
    this.wifiIP,
    this.wifiName,
  });

  final String locationServiceAuthorizationStatus;
  final String locationServiceAuthorization;
  final String wifiBSSID;
  final String wifiIP;
  final String wifiName;
}

class SynchronousCarrierInfo {
  SynchronousCarrierInfo({
    this.allowsVOIP,
    this.carrierName,
    this.isoCountryCode,
    this.mobileCountryCode,
    this.mobileNetworkCode,
  });

  final String allowsVOIP;
  final String carrierName;
  final String isoCountryCode;
  final String mobileCountryCode;
  final String mobileNetworkCode;
}
