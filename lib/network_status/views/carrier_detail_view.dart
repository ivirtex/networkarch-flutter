// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared.dart';

class CarrierDetailView extends StatelessWidget {
  const CarrierDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Carrier Details'),
      child: _buildDataList(context),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrier Details',
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
            switch (state.carrierStatus) {
              case NetworkStatus.inital:
              case NetworkStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case NetworkStatus.permissionIssue:
                return const Center(
                  child: Text('Carrier data permission denied'),
                );
              case NetworkStatus.failure:
              case NetworkStatus.success:
                return Column(
                  children: [
                    RoundedList(
                      children: [
                        ListTextLine(
                          widgetL: const Text('Allows VOIP'),
                          widgetR: Text(
                            state.carrierInfo?.allowsVOIP.toString() ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Carrier name'),
                          widgetR: Text(
                            state.carrierInfo?.carrierName ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('ISO country code'),
                          widgetR: Text(
                            state.carrierInfo?.isoCountryCode ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Mobile country code'),
                          widgetR: Text(
                            state.carrierInfo?.mobileCountryCode ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Mobile network code'),
                          widgetR: Text(
                            state.carrierInfo?.mobileNetworkCode ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Connection status'),
                          widgetR: ConnectionStatus(
                            state.carrierStatus,
                            connectionChecker: () =>
                                state.carrierInfo?.isCarrierConnected ?? false,
                          ),
                        ),
                      ],
                    ),
                    RoundedList(
                      children: [
                        ListTextLine(
                          widgetL: const Text('External IP'),
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
