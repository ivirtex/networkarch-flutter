// Project imports:
import 'package:network_arch/ip_geo/data_provider/ip_geo_api.dart';
import 'package:network_arch/ip_geo/models/ip_geo_response.dart';

class IpGeoNoIpSpecified implements Exception {}

class IpGeoRepository {
  IpGeoRepository({IpGeoApi? api}) : _ipGeoApi = api ?? IpGeoApi();

  final IpGeoApi _ipGeoApi;

  Future<IpGeoResponse> getIpGeolocation(String ip) {
    if (ip.isEmpty) {
      throw IpGeoNoIpSpecified();
    }

    return _ipGeoApi.getIpGeolocation(ip);
  }
}
