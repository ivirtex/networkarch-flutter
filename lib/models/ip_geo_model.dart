// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:network_arch/models/ip_geo_response.dart';

class IPGeoModel extends ChangeNotifier {
  bool isFetching = false;
  bool hasBeenFetchedAtLeastOnce = false;

  late StreamController<IpGeoResponse> _controller;

  final Set<Marker> markers = {};
  final CameraPosition startPosition =
      const CameraPosition(target: LatLng(45, 0));

  Future<void> fetchDataFor({required String ip}) async {
    final http.Response response =
        await http.get(Uri.parse('https://freegeoip.app/json/$ip'));

    isFetching = false;
    notifyListeners();

    if (response.statusCode == 200) {
      _controller.add(IpGeoResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>));
    } else {
      _controller.addError('Failed to load data');
    }
  }

  Stream<IpGeoResponse> streamOfResponses() {
    void stopStream() {
      _controller.addError('Action cancelled');
    }

    _controller = StreamController<IpGeoResponse>(
      onCancel: stopStream,
      onPause: stopStream,
    );

    return _controller.stream.asBroadcastStream();
  }
}
