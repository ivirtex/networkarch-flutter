// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_arch/services/widgets/platform_widget.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/services/widgets/shared_widgets.dart';

class WiFiDetailView extends StatelessWidget {
  const WiFiDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text(
              'Wake On LAN',
            ),
          )
        ],
        body: _buildDataList(context),
      ),
    );
  }

  Widget _buildAndroid(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wi-Fi Details',
        ),
        iconTheme: Theme.of(context).iconTheme,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: _buildDataList(context),
    );
  }

  Padding _buildDataList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        spacing: 5,
        children: [
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('SSID'),
              textR: Text(
                  context.watch<ConnectivityModel>().globalWifiInfo.wifiSSID ??
                      'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('BSSID'),
              textR: Text(
                  context.watch<ConnectivityModel>().globalWifiInfo.wifiBSSID ??
                      'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('Local IPv4'),
              textR: Text(
                  context.watch<ConnectivityModel>().globalWifiInfo.wifiIPv4 ??
                      'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('Local IPv6'),
              textR: Text(
                  context.watch<ConnectivityModel>().globalWifiInfo.wifiIPv6 ??
                      'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('Public IPv4'),
              textR: Text(context
                      .watch<ConnectivityModel>()
                      .globalWifiInfo
                      .publicIPv4 ??
                  'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('Broadcast address'),
              textR: Text(context
                      .watch<ConnectivityModel>()
                      .globalWifiInfo
                      .wifiBroadcast ??
                  'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('Gateway'),
              textR: Text(context
                      .watch<ConnectivityModel>()
                      .globalWifiInfo
                      .wifiGateway ??
                  'N/A'),
            ),
          ),
          DataCard(
            margin: 5,
            child: DataLine(
              textL: const Text('Submask'),
              textR: Text(context
                      .watch<ConnectivityModel>()
                      .globalWifiInfo
                      .wifiSubmask ??
                  'N/A'),
            ),
          ),
        ],
      ),
    );
  }
}
