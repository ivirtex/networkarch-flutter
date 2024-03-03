// Package imports:
import 'dart:io';

import 'package:carrier_info/carrier_info.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/network_status/models/models.dart';

class CarrierDataProvider {
  Future<CarrierInfoModel> getCellularData() async {
    var carrierInfoModel = const CarrierInfoModel();

    if (Platform.isIOS) {
      final carrierInfo = await CarrierInfo.getIosInfo();
      final carrierData = carrierInfo.carrierData.first;

      carrierInfoModel = CarrierInfoModel(
        allowsVOIP: carrierData.carrierAllowsVOIP,
        carrierName: carrierData.carrierName,
        isoCountryCode: carrierData.isoCountryCode,
        mobileCountryCode: carrierData.mobileCountryCode,
        mobileNetworkCode: carrierData.mobileNetworkCode,
        radioType: carrierInfo.carrierRadioAccessTechnologyTypeList.first,
      );
    } else if (Platform.isAndroid) {
      final carrierInfo = await CarrierInfo.getAndroidInfo();
      final carrierData = carrierInfo?.telephonyInfo.first;

      carrierInfoModel = CarrierInfoModel(
        carrierName: carrierData?.carrierName,
        isoCountryCode: carrierData?.isoCountryCode,
        mobileCountryCode: carrierData?.mobileCountryCode,
        mobileNetworkCode: carrierData?.mobileNetworkCode,
        mobileNetworkOperator: carrierData?.networkOperatorName,
        networkGeneration: carrierData?.networkGeneration,
        radioType: carrierData?.radioType,
      );
    }

    return carrierInfoModel;
  }

  Future<PermissionStatus> getPermissionStatus() {
    return Permission.phone.status;
  }
}
