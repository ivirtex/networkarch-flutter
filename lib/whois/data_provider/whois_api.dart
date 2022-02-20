// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

class WhoisRequestFailure implements Exception {}

class WhoisNotFound implements Exception {}

class WhoisApi {
  WhoisApi({http.Client? client}) : _httpClient = client ?? http.Client();

  static const String _baseUrl = 'http://ivirtex.tplinkdns.com:2137/whois';
  final http.Client _httpClient;

  Future<String> getWhois(String domain) async {
    final request = Uri.parse('$_baseUrl/$domain');
    final response = await _httpClient.get(request);

    if (response.statusCode == 400) {
      throw WhoisRequestFailure();
    }

    if (response.statusCode != 200) {
      throw WhoisNotFound();
    }

    final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;

    return bodyJson['response'] as String;
  }
}
