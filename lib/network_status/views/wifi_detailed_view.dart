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
            return state.wifiStatus == NetworkStatus.success
                ? RoundedList(
                    children: [
                      ListTextLine(
                        widgetL: const Text('SSID'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiSSID ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('BSSID'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiBSSID ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Local IPv4'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiIPv4 ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Local IPv6'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiIPv6 ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Broadcast address'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiBroadcast ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Gateway'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiGateway ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Submask'),
                        widgetR: SelectableText(
                          state.wifiInfo!.wifiSubmask ?? 'N/A',
                        ),
                      ),
                      if (state.extIpStatus == NetworkStatus.success)
                        ListTextLine(
                          widgetL: const Text('External IPv4'),
                          widgetR: SelectableText(state.extIP ?? 'N/A'),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        )
                      else if (state.extIpStatus == NetworkStatus.loading)
                        const ListTextLine(widgetL: Text('External IPv4'))
                      else
                        ListTextLine(
                          widgetL: const Text('External IPv4'),
                          widgetR: const Text('N/A'),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        ),
                    ],
                  )
                : const RoundedList(
                    children: [
                      ListTextLine(widgetL: Text('SSID')),
                      ListTextLine(widgetL: Text('BSSID')),
                      ListTextLine(widgetL: Text('Local IPv4')),
                      ListTextLine(widgetL: Text('Local IPv6')),
                      ListTextLine(widgetL: Text('Broadcast address')),
                      ListTextLine(widgetL: Text('Gateway')),
                      ListTextLine(widgetL: Text('Submask')),
                      ListTextLine(widgetL: Text('External IP')),
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
