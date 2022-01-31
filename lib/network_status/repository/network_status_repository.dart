import 'dart:async';

import 'package:flutter/services.dart';
import 'package:network_arch/network_status/netword_status.dart';
import 'package:rxdart/rxdart.dart';

class NetworkStatusRepository {
  final _wifiDataProvider = WifiDataProvider();
  final _carrierDataProvider = CarrierDataProvider();
  final _externalIpProvider = ExternalIpProvider();

  Stream<NetworkInfoModel> getNetworkInfoStream() {
    final zipped = ZipStream.zip2(
      _getWifiInfoStream(),
      _getCarrierInfoStream(),
      (WifiInfoModel wifi, CarrierInfoModel carrier) =>
          NetworkInfoModel(wifiInfo: wifi, carrierInfo: carrier),
    );

    return zipped;
  }

  Stream<WifiInfoModel> _getWifiInfoStream() {
    late StreamController<WifiInfoModel> controller;
    Timer? timer;

    WifiInfoModel? wifiInfo;

    Future<void> fetchData(_) async {
      try {
        wifiInfo = await _wifiDataProvider.getDataForIOS();
      } on MissingPluginException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await _wifiDataProvider.getDataForAndroid();
      } on PlatformException catch (_) {
        // print("exception catched: " + err.toString());

        wifiInfo = await _wifiDataProvider.getDataForAndroid();
      } catch (e) {
        rethrow;
      }
    }

    void startTimer() {
      timer = Timer.periodic(const Duration(seconds: 5), fetchData);
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

    CarrierInfoModel? carrierInfo;

    Future<void> fetchData(_) async {
      carrierInfo = await _carrierDataProvider.getCellularData();

      carrierInfo != null
          ? controller.add(carrierInfo!)
          : controller.addError('Error fetching cellular data');
    }

    void startTimer() {
      timer = Timer.periodic(const Duration(seconds: 5), fetchData);
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
