// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:carrier_info/carrier_info.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

class ConnectivityModel {
  late SynchronousWifiInfo globalWifiInfo;
  late SynchronousCarrierInfo globalCarrierInfo;

  Future<SynchronousWifiInfo> _getDataForIOS() async {
    return SynchronousWifiInfo(
      locationServiceAuthorizationStatus:
          await NetworkInfo().getLocationServiceAuthorization(),
      locationServiceAuthorization:
          await NetworkInfo().requestLocationServiceAuthorization(),
      wifiSSID: await NetworkInfo().getWifiName(),
      wifiBSSID: await NetworkInfo().getWifiBSSID(),
      wifiIPv4: await NetworkInfo().getWifiIP(),
      wifiIPv6: await NetworkInfo().getWifiIPv6(),
      wifiBroadcast: await NetworkInfo().getWifiBroadcast(),
      wifiGateway: await NetworkInfo().getWifiGatewayIP(),
      wifiSubmask: await NetworkInfo().getWifiSubmask(),
    );
  }

  Future<SynchronousWifiInfo> _getDataForAndroid() async {
    return SynchronousWifiInfo(
      wifiSSID: await NetworkInfo().getWifiName(),
      wifiBSSID: await NetworkInfo().getWifiBSSID(),
      wifiIPv4: await NetworkInfo().getWifiIP(),
      wifiIPv6: await NetworkInfo().getWifiIPv6(),
      wifiBroadcast: await NetworkInfo().getWifiBroadcast(),
      wifiGateway: await NetworkInfo().getWifiGatewayIP(),
      wifiSubmask: await NetworkInfo().getWifiSubmask(),
    );
  }

  Stream<SynchronousWifiInfo> _wifiInfoStream() {
    late StreamController<SynchronousWifiInfo> controller;
    Timer? timer;

    SynchronousWifiInfo wifiInfo;

    Future<void> fetchData(_) async {
      try {
        wifiInfo = await _getDataForIOS();
      } on MissingPluginException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await _getDataForAndroid();
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await _getDataForAndroid();
      }

      globalWifiInfo = wifiInfo;

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

  Future<PublicIpModel> fetchPublicIP() async {
    final http.Response response;

    response = await http.get(Uri.parse('https://api.ipify.org?format=json'));

    if (response.statusCode == 200) {
      return PublicIpModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      // return PublicIpModel();

      throw Exception('Failed to fetch IP');
    }
  }
}

class SynchronousWifiInfo {
  SynchronousWifiInfo({
    this.locationServiceAuthorizationStatus,
    this.locationServiceAuthorization,
    this.wifiSSID,
    this.wifiBSSID,
    this.wifiIPv4,
    this.wifiIPv6,
    this.wifiBroadcast,
    this.wifiGateway,
    this.wifiSubmask,
  });

  final LocationAuthorizationStatus? locationServiceAuthorizationStatus;
  final LocationAuthorizationStatus? locationServiceAuthorization;
  final String? wifiSSID;
  final String? wifiBSSID;
  final String? wifiIPv4;
  final String? wifiIPv6;
  final String? wifiBroadcast;
  final String? wifiGateway;
  final String? wifiSubmask;
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

class PublicIpModel {
  PublicIpModel({this.ip});

  factory PublicIpModel.fromJson(Map<String, dynamic> json) {
    return PublicIpModel(
      ip: json['ip'] as String?,
    );
  }

  final String? ip;

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
    };
  }
}

class NoSimCardException implements Exception {}
