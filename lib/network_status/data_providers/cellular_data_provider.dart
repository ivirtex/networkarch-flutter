import 'package:carrier_info/carrier_info.dart';
import 'package:network_arch/network_status/models/models.dart';

class CarrierDataProvider {
  final carrierInfo = CarrierInfo;

  Future<CarrierInfoModel> getCellularData() async {
    return CarrierInfoModel(
      allowsVOIP: await CarrierInfo.allowsVOIP,
      carrierName: await CarrierInfo.carrierName,
      isoCountryCode: await CarrierInfo.isoCountryCode,
      mobileCountryCode: await CarrierInfo.mobileCountryCode,
      mobileNetworkCode: await CarrierInfo.mobileNetworkCode,
      networkGeneration: await CarrierInfo.networkGeneration,
      radioType: await CarrierInfo.radioType,
    );
  }
}
