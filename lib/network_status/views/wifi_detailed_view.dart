// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared.dart';

class WifiDetailedView extends StatelessWidget {
  const WifiDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Wi-Fi Details'),
      child: _buildDataList(context),
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
            switch (state.wifiStatus) {
              case NetworkStatus.inital:
              case NetworkStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case NetworkStatus.permissionIssue:
                return const ErrorCard(
                  message: 'Permission to access Wi-Fi information denied.',
                );
              case NetworkStatus.success:
              case NetworkStatus.failure:
                return Column(
                  children: [
                    RoundedList(
                      children: [
                        ListTextLine(
                          widgetL: const Text('SSID'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiSSID ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('BSSID'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiBSSID ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Local IPv4'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiIPv4 ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Local IPv6'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiIPv6 ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Broadcast address'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiBroadcast ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Gateway'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiGateway ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Submask'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiSubmask ?? 'N/A',
                          ),
                        ),
                      ],
                    ),
                    RoundedList(
                      children: [
                        ListTextLine(
                          widgetL: const Text('External IPv4'),
                          subtitle: const Text('Tap to refresh'),
                          widgetR: state.extIpStatus == NetworkStatus.inital ||
                                  state.extIpStatus == NetworkStatus.loading
                              ? const ListCircularProgressIndicator()
                              : state.extIpStatus == NetworkStatus.failure
                                  ? const ErrorCard(
                                      message: 'Failed to get external IP',
                                    )
                                  : SelectableText(
                                      state.extIP ?? 'N/A',
                                    ),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        ),
                      ],
                    ),
                  ],
                );
            }
          },
        ),
      ],
    );
  }

  void _handleExtIPRefresh(BuildContext context) {
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
  }
}
