import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class WifiDetailsView extends StatelessWidget {
  const WifiDetailsView({Key? key}) : super(key: key);

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
          ),
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
      ),
      body: _buildDataList(context),
    );
  }

  Widget _buildDataList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.listSpacing),
      child: BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
        builder: (context, state) {
          if (state is NetworkStatusUpdateSuccess) {
            return RoundedList(
              children: [
                DataLine(
                  textL: const Text('SSID'),
                  textR: Text(state.wifiInfo!.wifiBSSID ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('BSSID'),
                  textR: Text(state.wifiInfo!.wifiBSSID ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Local IPv4'),
                  textR: Text(state.wifiInfo!.wifiIPv4 ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Local IPv6'),
                  textR: Text(state.wifiInfo!.wifiIPv6 ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Broadcast address'),
                  textR: Text(state.wifiInfo!.wifiBroadcast ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Gateway'),
                  textR: Text(state.wifiInfo!.wifiGateway ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Submask'),
                  textR: Text(state.wifiInfo!.wifiSubmask ?? 'N/A'),
                ),
              ],
            );
          } else {
            return const RoundedList(
              children: [
                DataLine(
                  textL: Text('SSID'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
                DataLine(
                  textL: Text('BSSID'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
                DataLine(
                  textL: Text('Local IPv4'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
                DataLine(
                  textL: Text('Local IPv6'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
                DataLine(
                  textL: Text('Broadcast address'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
                DataLine(
                  textL: Text('Gateway'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
                DataLine(
                  textL: Text('Submask'),
                  textR: CircularProgressIndicator.adaptive(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
