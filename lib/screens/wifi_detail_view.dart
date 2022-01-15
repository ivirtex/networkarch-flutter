// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class WiFiDetailView extends StatefulWidget {
  const WiFiDetailView({Key? key}) : super(key: key);

  @override
  State<WiFiDetailView> createState() => _WiFiDetailViewState();
}

class _WiFiDetailViewState extends State<WiFiDetailView> {
  late Future<PublicIpModel> futureIpModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    futureIpModel = context.read<ConnectivityModel>().fetchPublicIP();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text(
              'Wi-Fi Details',
            ),
          )
        ],
        body: _buildDataList(context),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
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

  RoundedList _buildDataList(BuildContext context) {
    return RoundedList(
      children: [
        DataLine(
          textL: const Text('SSID'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiSSID ?? 'N/A',
          ),
        ),
        DataLine(
          textL: const Text('BSSID'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiBSSID ??
                'N/A',
          ),
        ),
        DataLine(
          textL: const Text('Local IPv4'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiIPv4 ?? 'N/A',
          ),
        ),
        DataLine(
          textL: const Text('Local IPv6'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiIPv6 ?? 'N/A',
          ),
        ),
        DataLine(
          textL: const Text('Public IPv4'),
          textR: FutureBuilder(
            future: futureIpModel,
            initialData: null,
            builder:
                (BuildContext ctx, AsyncSnapshot<PublicIpModel?> snapshot) {
              if (snapshot.hasError) {
                return const Text('Error when fetching IP');
              }

              if (snapshot.hasData) {
                return Text(snapshot.data!.ip ?? 'N/A');
              } else {
                return const SizedBox(
                  height: 15.0,
                  width: 15.0,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
            },
          ),
        ),
        DataLine(
          textL: const Text('Broadcast address'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiBroadcast ??
                'N/A',
          ),
        ),
        DataLine(
          textL: const Text('Gateway'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiGateway ??
                'N/A',
          ),
        ),
        DataLine(
          textL: const Text('Submask'),
          textR: Text(
            context.watch<ConnectivityModel>().globalWifiInfo.wifiSubmask ??
                'N/A',
          ),
        ),
      ],
    );
  }
}
