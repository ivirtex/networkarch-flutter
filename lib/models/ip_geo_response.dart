class IpGeoResponse {
  IpGeoResponse({
    this.ip,
    this.countryCode,
    this.countryName,
    this.regionCode,
    this.regionName,
    this.city,
    this.zipCode,
    this.timeZone,
    this.latitude,
    this.longitude,
    this.metroCode,
  });

  factory IpGeoResponse.fromJson(Map<String, dynamic> json) {
    return IpGeoResponse(
      ip: json['ip'] as String?,
      countryCode: json['country_code'] as String?,
      countryName: json['country_name'] as String?,
      regionCode: json['region_code'] as String?,
      regionName: json['region_name'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      timeZone: json['time_zone'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      metroCode: json['metro_code'] as int?,
    );
  }

  final String? ip;
  final String? countryCode;
  final String? countryName;
  final String? regionCode;
  final String? regionName;
  final String? city;
  final String? zipCode;
  final String? timeZone;
  final double? latitude;
  final double? longitude;
  final int? metroCode;

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'country_code': countryCode,
      'country_name': countryName,
      'region_code': regionCode,
      'region_name': regionName,
      'city': city,
      'zip_code': zipCode,
      'time_zone': timeZone,
      'latitude': latitude,
      'longitude': longitude,
      'metro_code': metroCode,
    };
  }
}
