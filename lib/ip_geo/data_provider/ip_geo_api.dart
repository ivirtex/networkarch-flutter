// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import 'package:network_arch/ip_geo/models/ip_geo_response.dart';

class IpGeoApi {
  IpGeoApi({http.Client? client}) : _httpClient = client ?? http.Client();

  static const String _baseUrl = 'http://ip-api.com/json';
  final http.Client _httpClient;

  Future<IpGeoResponse> getIpGeolocation(String ip) async {
    final request = Uri.parse('$_baseUrl/$ip');
    late final http.Response response;

    try {
      response = await _httpClient.get(request);
    } catch (exc, stackTrace) {
      Sentry.captureException(exc, stackTrace: stackTrace);

      throw IpGeoRequestFailure();
    }
    if (response.statusCode != 200) {
      throw IpGeoRequestFailure();
    }

    late final Map<String, dynamic> bodyJson;

    try {
      bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (exc, stackTrace) {
      await Sentry.captureException(exc, stackTrace: stackTrace);

      throw IpGeoNotFound();
    }

    if (bodyJson['status'] == 'fail' || bodyJson.isEmpty) {
      throw IpGeoNotFound();
    }

    return IpGeoResponse.fromJson(bodyJson);
  }
}

class IpGeoRequestFailure implements Exception {}

class IpGeoNotFound implements Exception {}
