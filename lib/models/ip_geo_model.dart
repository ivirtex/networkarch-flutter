import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:network_arch/models/ip_geo_response.dart';

class IPGeoModel extends ChangeNotifier {
  bool isFetching = false;

  Future<IpGeoResponse> fetchDataFor({required String ip}) async {
    final http.Response response =
        await http.get(Uri.parse('https://freegeoip.app/json/$ip'));

    if (response.statusCode == 200) {
      return IpGeoResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
