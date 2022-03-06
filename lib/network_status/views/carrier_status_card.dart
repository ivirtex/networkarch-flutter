// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/adaptive_button.dart';
import 'package:network_arch/shared/list_circular_progress_indicator.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class CarrierStatusCard extends StatelessWidget {
  const CarrierStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataCard(
      margin: EdgeInsetsDirectional.zero,
      child: Column(
        children: [
          BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
            builder: (context, state) {
              return Column(
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
                        state,
                        connectionChecker: () =>
                            state.carrierInfo!.isoCountryCode != null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Text('Network Generation'),
                      const Spacer(),
                      if (state.status == NetworkStatus.success)
                        Text(state.carrierInfo!.networkGeneration ?? 'N/A')
                      else
                        const ListCircularProgressIndicator(),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          AdaptiveButton(
            text: 'Detailed view',
            onPressed: () => Navigator.pushNamed(context, '/carrier'),
          ),
        ],
      ),
    );
  }
}
