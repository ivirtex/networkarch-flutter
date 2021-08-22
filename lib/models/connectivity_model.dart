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
      wifiBSSID: await NetworkInfo().getWifiBSSID(),
      wifiIP: await NetworkInfo().getWifiIP(),
      wifiName: await NetworkInfo().getWifiName(),
    );
  }

  Stream<SynchronousWifiInfo> _wifiInfoStream() {
    late StreamController<SynchronousWifiInfo> controller;
    Timer? timer;

    SynchronousWifiInfo wifiInfo;

    Future<void> fetchData(_) async {
      try {
        wifiInfo = await getDataForIOS();
      } on MissingPluginException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await getDataForAndroid();
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await getDataForAndroid();
      }

      controller.add(wifiInfo);
    }

    void startTimer() {
      timer = Timer.periodic(const Duration(seconds: 1), fetchData);
    }

    void stopTimer() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<SynchronousWifiInfo>(
      onCancel: stopTimer,
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
    );

    return controller.stream;
  }

  Stream<SynchronousCarrierInfo> _cellularInfoStream() {
    late StreamController<SynchronousCarrierInfo> controller;
    Timer? timer;

    Future<void> fetchData(_) async {
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

        controller.add(carrierInfo);
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        controller.addError(NoSimCardException());
      }
    }

    void startTimer() {
      timer = Timer.periodic(const Duration(seconds: 1), fetchData);
    }

    void stopTimer() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<SynchronousCarrierInfo>(
      onCancel: stopTimer,
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
    );

    return controller.stream;
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

class NoSimCardException implements Exception {}
