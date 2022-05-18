// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/list_circular_progress_indicator.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class CarrierStatusCard extends StatelessWidget {
  const CarrierStatusCard({Key? key}) : super(key: key);

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
                      const Icon(Icons.cell_tower_rounded),
                      const SizedBox(width: 5),
                      Text(
                        'Carrier',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const Spacer(),
                      ConnectionStatus(
                        state.carrierStatus,
                        connectionChecker: () =>
                            state.carrierInfo?.isCarrierConnected ?? false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Text('Network Generation'),
                      const Spacer(),
                      if (state.carrierStatus == NetworkStatus.success)
                        Text(state.carrierInfo!.networkGeneration ?? 'N/A')
                      else if (state.carrierStatus ==
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
                onPressed: state.isCarrierConnected
                    ? () => Navigator.pushNamed(context, '/carrier')
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
