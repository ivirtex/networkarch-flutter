// Flutter imports:
import 'package:flutter/material.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/services/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

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
                textL: 'SSID',
                textR:
                    context.watch<ConnectivityModel>().globalWifiInfo.wifiSSID,
              ),
              DataLine(
                textL: 'BSSID',
                textR:
                    context.watch<ConnectivityModel>().globalWifiInfo.wifiBSSID,
              ),
              DataLine(
                textL: 'IPv4',
                textR:
                    context.watch<ConnectivityModel>().globalWifiInfo.wifiIPv4,
              ),
              DataLine(
                textL: 'IPv6',
                textR:
                    context.watch<ConnectivityModel>().globalWifiInfo.wifiIPv6,
              ),
              DataLine(
                textL: 'Broadcast address',
                textR: context
                    .watch<ConnectivityModel>()
                    .globalWifiInfo
                    .wifiBroadcast,
              ),
              DataLine(
                textL: 'Gateway',
                textR: context
                    .watch<ConnectivityModel>()
                    .globalWifiInfo
                    .wifiGateway,
              ),
              DataLine(
                textL: 'Submask',
                textR: context
                    .watch<ConnectivityModel>()
                    .globalWifiInfo
                    .wifiSubmask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
