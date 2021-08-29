// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/services/widgets/shared_widgets.dart';

class WiFiDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wi-Fi Details',
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DataCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DataLine(
                textL: const Text('SSID'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiSSID ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('BSSID'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiBSSID ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('Local IPv4'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiIPv4 ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('Local IPv6'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiIPv6 ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('Public IPv4'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiIPv4 ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('Broadcast address'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiBroadcast ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('Gateway'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiGateway ??
                    'N/A'),
              ),
              DataLine(
                textL: const Text('Submask'),
                textR: Text(context
                        .watch<ConnectivityModel>()
                        .globalWifiInfo
                        .wifiSubmask ??
                    'N/A'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
