// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';

class NetworkStatusRepository {
  final _wifiDataProvider = WifiDataProvider();
  final _carrierDataProvider = CarrierDataProvider();
  final _externalIpProvider = ExternalIpProvider();

  Stream<WifiInfoModel> getWifiInfoStream() {
    late StreamController<WifiInfoModel> controller;
    Timer? timer;

    WifiInfoModel wifiInfo;

    Future<void> fetchData(_) async {
      final wifiPermStatus = await _wifiDataProvider.getPermissionStatus();

      if (wifiPermStatus == PermissionStatus.granted) {
        wifiInfo = await _wifiDataProvider.getWifiData();

        controller.add(wifiInfo);
      } else {
        controller.addError(
          NetworkStatus.permissionIssue,
          StackTrace.current,
        );
      }
    }

    void startTimer() {
      timer = Timer.periodic(const Duration(seconds: 1), fetchData);
    }

    void stopTimer() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<WifiInfoModel>(
      onCancel: stopTimer,
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
    );

    return controller.stream;
  }

  Stream<CarrierInfoModel> getCarrierInfoStream() {
    late StreamController<CarrierInfoModel> controller;
    Timer? timer;

    CarrierInfoModel? carrierInfo;

    Future<void> fetchData(_) async {
      if (Platform.isAndroid) {
        if (await _carrierDataProvider.getPermissionStatus() ==
            PermissionStatus.denied) {
          controller.addError(
            NetworkStatus.permissionIssue,
            StackTrace.current,
          );
        }
      }

      carrierInfo = await _carrierDataProvider.getCellularData();

      if (carrierInfo != null) {
        controller.add(carrierInfo!);
      }
    }

    void startTimer() {
      timer = Timer.periodic(const Duration(seconds: 1), fetchData);
    }

    void stopTimer() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<CarrierInfoModel>(
      onCancel: stopTimer,
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
    );

    return controller.stream;
  }

  Future<String?> fetchExternalIp() {
    return _externalIpProvider.getExternalIp();
  }
}
