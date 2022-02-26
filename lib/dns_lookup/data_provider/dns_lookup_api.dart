// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:network_arch/dns_lookup/models/dns_lookup_response.dart';

class DnsLookupApi {
  DnsLookupApi({http.Client? client}) : _httpClient = client ?? http.Client();

  static const String _baseUrl = 'https://dns.google.com/resolve';
  final http.Client _httpClient;

  Future<DnsLookupResponse> lookup(
    String hostname, {
    required int type,
  }) async {
    final request = Uri.parse('$_baseUrl?name=$hostname&type=$type');
    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw DnsLookupRequestFailure();
    }

    final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    // bodyJson = bodyJson.map((key, value) {
    //   return MapEntry(key.toLowerCase(), value);
    // });

    if (bodyJson['Status'] != 0 || bodyJson['Answer'] == null) {
      throw DnsLookupNotFound();
    }

    return DnsLookupResponse.fromJson(bodyJson);
  }
}

class DnsLookupRequestFailure implements Exception {}

class DnsLookupNotFound implements Exception {}
