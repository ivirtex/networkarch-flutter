// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared.dart';

class WifiDetailedView extends StatelessWidget {
  const WifiDetailedView({Key? key}) : super(key: key);

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
    return ContentListView(
      children: [
        BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
          builder: (context, state) {
            return state.status == NetworkStatus.success
                ? RoundedList(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTextLine(
                        textL: const Text('SSID'),
                        textR: Text(state.wifiInfo!.wifiSSID ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('BSSID'),
                        textR: Text(state.wifiInfo!.wifiBSSID ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Local IPv4'),
                        textR: Text(state.wifiInfo!.wifiIPv4 ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Local IPv6'),
                        textR: Text(state.wifiInfo!.wifiIPv6 ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Broadcast address'),
                        textR: Text(state.wifiInfo!.wifiBroadcast ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Gateway'),
                        textR: Text(state.wifiInfo!.wifiGateway ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Submask'),
                        textR: Text(state.wifiInfo!.wifiSubmask ?? 'N/A'),
                      ),
                      if (state.extIpStatus == ExtIpStatus.success)
                        ListTextLine(
                          textL: const Text('External IPv4'),
                          textR: Text(state.extIP.toString()),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        )
                      else if (state.extIpStatus == ExtIpStatus.loading)
                        const ListTextLine(textL: Text('External IPv4'))
                      else
                        ListTextLine(
                          textL: const Text('External IPv4'),
                          textR: const Text('N/A'),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        ),
                    ],
                  )
                : const RoundedList(
                    children: [
                      ListTextLine(textL: Text('SSID')),
                      ListTextLine(textL: Text('BSSID')),
                      ListTextLine(textL: Text('Local IPv4')),
                      ListTextLine(textL: Text('Local IPv6')),
                      ListTextLine(textL: Text('Broadcast address')),
                      ListTextLine(textL: Text('Gateway')),
                      ListTextLine(textL: Text('Submask')),
                      ListTextLine(textL: Text('External IP')),
                    ],
                  );
          },
        ),
      ],
    );
  }

  void _handleExtIPRefresh(BuildContext context) {
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
  }
}
