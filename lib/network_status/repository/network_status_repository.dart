// Dart imports:
import 'dart:async';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';

class NetworkStatusRepository {
  final _wifiDataProvider = WifiDataProvider();
  final _carrierDataProvider = CarrierDataProvider();
  final _externalIpProvider = ExternalIpProvider();

  Stream<NetworkInfoModel> getNetworkInfoStream() {
    final zipped = ZipStream.zip2(
      _getWifiInfoStream(),
      _getCarrierInfoStream(),
      (WifiInfoModel wifi, CarrierInfoModel carrier) => NetworkInfoModel(
        wifiInfo: wifi,
        carrierInfo: carrier,
      ),
    );

    return zipped;
  }

  Stream<WifiInfoModel> _getWifiInfoStream() {
    late StreamController<WifiInfoModel> controller;
    Timer? timer;

    WifiInfoModel wifiInfo;

    Future<void> fetchData(_) async {
      wifiInfo = await _wifiDataProvider.getWifiData();

      controller.add(wifiInfo);
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

  Stream<CarrierInfoModel> _getCarrierInfoStream() {
    late StreamController<CarrierInfoModel> controller;
    Timer? timer;

    CarrierInfoModel carrierInfo;

    Future<void> fetchData(_) async {
      carrierInfo = await _carrierDataProvider.getCellularData();

      controller.add(carrierInfo);
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
