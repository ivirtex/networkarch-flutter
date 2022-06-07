// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/list_circular_progress_indicator.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/themes.dart';

class CarrierStatusCard extends StatelessWidget {
  const CarrierStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
      builder: (context, state) {
        return PlatformWidget(
          androidBuilder: (context) {
            return DataCard(
              margin: EdgeInsetsDirectional.zero,
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cell_tower_rounded,
                            color: Themes.getPlatformIconColor(context),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Carrier',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
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
                    onPressed: state.isCarrierConnected
                        ? () => Navigator.pushNamed(context, '/carrier')
                        : null,
                    child: const Text('Detailed view'),
                  ),
                ],
              ),
            );
          },
          iosBuilder: (context) {
            return CupertinoListSection.insetGrouped(
              hasLeading: false,
              header: const Text('Carrier'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cell_tower_rounded,
                            color: Themes.getPlatformIconColor(context),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            state.carrierInfo?.carrierName ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
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
                      const SizedBox(height: 20.0),
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
                ),
                CupertinoListTile.notched(
                  leadingSize: 0.0,
                  leadingToTitle: 0.0,
                  leading: const SizedBox(),
                  title: const Text('Detailed view'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: state.isCarrierConnected
                      ? () => Navigator.of(context).pushNamed('/carrier')
                      : null,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
