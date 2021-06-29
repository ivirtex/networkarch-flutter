// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:carrier_info/carrier_info.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectivityModel {
  Future<SynchronousWifiInfo> getDataForIOS() async {
    return SynchronousWifiInfo(
      locationServiceAuthorizationStatus:
          await NetworkInfo().getLocationServiceAuthorization(),
      locationServiceAuthorization:
          await NetworkInfo().requestLocationServiceAuthorization(),
      wifiBSSID: await NetworkInfo().getWifiBSSID(),
      wifiIP: await NetworkInfo().getWifiIP(),
      wifiName: await NetworkInfo().getWifiName(),
    );
  }

  Future<SynchronousWifiInfo> getDataForAndroid() async {
    return SynchronousWifiInfo(
      locationServiceAuthorizationStatus: null,
      locationServiceAuthorization: null,
      wifiBSSID: await NetworkInfo().getWifiBSSID(),
      wifiIP: await NetworkInfo().getWifiIP(),
      wifiName: await NetworkInfo().getWifiName(),
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

      // print("value of wifiInfo: $wifiInfo");

      yield wifiInfo;
    }
  }

  Stream<SynchronousCarrierInfo> _cellularInfoStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));

      SynchronousCarrierInfo carrierInfo;

      try {
        carrierInfo = SynchronousCarrierInfo(
          allowsVOIP: await CarrierInfo.allowsVOIP,
          carrierName: await CarrierInfo.carrierName,
          isoCountryCode: await CarrierInfo.isoCountryCode,
          mobileCountryCode: await CarrierInfo.mobileCountryCode,
          mobileNetworkCode: await CarrierInfo.mobileNetworkCode,
          networkGeneration: await CarrierInfo.networkGeneration,
          radioType: await CarrierInfo.radioType,
        );

        // carrierInfo = (await CarrierInfo.all)!;
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        throw Exception("SIM_CARD_NOT_READY");
      }

      print("value of carrierInfo: $carrierInfo");

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

  final LocationAuthorizationStatus? locationServiceAuthorizationStatus;
  final LocationAuthorizationStatus? locationServiceAuthorization;
  final String? wifiBSSID;
  final String? wifiIP;
  final String? wifiName;
}

class SynchronousCarrierInfo {
  SynchronousCarrierInfo({
    required this.allowsVOIP,
    this.carrierName,
    this.isoCountryCode,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.networkGeneration,
    this.radioType,
  });

  final bool allowsVOIP;
  final String? carrierName;
  final String? isoCountryCode;
  final String? mobileCountryCode;
  final String? mobileNetworkCode;
  final String? networkGeneration;
  final String? radioType;
}
