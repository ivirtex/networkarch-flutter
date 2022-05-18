// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/list_circular_progress_indicator.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class WifiStatusCard extends StatelessWidget {
  const WifiStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataCard(
      margin: EdgeInsetsDirectional.zero,
      child: BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
        builder: (context, state) {
          return Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wifi_rounded),
                      const SizedBox(width: 5),
                      const Text(
                        'Wi-Fi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const Spacer(),
                      ConnectionStatus(
                        state.wifiStatus,
                        connectionChecker: () => state.isWifiConnected,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Text('Local IP'),
                      const Spacer(),
                      if (state.wifiStatus == NetworkStatus.success)
                        Text(state.wifiInfo!.wifiIPv4 ?? 'N/A')
                      else if (state.wifiStatus ==
                          NetworkStatus.permissionIssue)
                        const Text('N/A')
                      else
                        const ListCircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AdaptiveButton(
                text: 'Detailed view',
                onPressed: state.isWifiConnected
                    ? () => Navigator.of(context).pushNamed('/wifi')
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
