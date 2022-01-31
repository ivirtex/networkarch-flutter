class CarrierInfoModel {
  CarrierInfoModel({
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
