import 'dart:convert';

import 'package:network_arch/ip_geo/models/ip_geo_response.dart';
import 'package:http/http.dart' as http;

class IpGeoRequestFailure implements Exception {}

class IpGeoNotFound implements Exception {}

class IpGeoApi {
  IpGeoApi({http.Client? client}) : _httpClient = client ?? http.Client();

  static const String _baseUrl = 'http://ip-api.com/json';
  final http.Client _httpClient;

  Future<IpGeoResponse> getIpGeolocation(String ip) async {
    final request = Uri.parse('$_baseUrl/$ip');
    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw IpGeoRequestFailure();
    }

    final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (bodyJson['status'] == 'fail' || bodyJson.isEmpty) {
      throw IpGeoNotFound();
    }

    return IpGeoResponse.fromJson(bodyJson);
  }
}
