// Flutter imports:
import 'package:flutter/cupertino.dart';
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
                  child: CircularProgressIndicator(),
                );
              case NetworkStatus.failure:
                return const Center(
                  child: Text('Failed to load carrier data'),
                );
              case NetworkStatus.permissionIssue:
                return const Center(
                  child: Text('Carrier data permission denied'),
                );
              case NetworkStatus.success:
                final widgets = <Widget>[];

                return PlatformWidget(
                  iosBuilder: (context) {
                    for (final carrier
                        in state.carrierInfo!.iosCarrierData!.carrierData) {
                      widgets.add(
                        CupertinoListSection.insetGrouped(
                          header: Text('${carrier.carrierName} details'),
                          children: [
                            CupertinoListTile.notched(
                              title: const Text('Carrier name'),
                              trailing: Text(
                                carrier.carrierName,
                              ),
                            ),
                            CupertinoListTile.notched(
                              title: const Text('ISO country code'),
                              trailing: Text(
                                carrier.isoCountryCode,
                              ),
                            ),
                            CupertinoListTile.notched(
                              title: const Text('Mobile country code'),
                              trailing: Text(
                                carrier.mobileCountryCode,
                              ),
                            ),
                            CupertinoListTile.notched(
                              title: const Text('Mobile network code'),
                              trailing: Text(
                                carrier.mobileNetworkCode,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    widgets.addAll(
                      [
                        CupertinoListSection.insetGrouped(
                          children: [
                            CupertinoListTile.notched(
                              title: const Text('Connection status'),
                              trailing: Text(
                                state.isCarrierConnected
                                    ? 'Connected'
                                    : 'Not connected',
                              ),
                            ),
                            CupertinoListTile.notched(
                              title: const Text('External IP'),
                              trailing: Text(
                                state.extIP ?? 'Unknown',
                              ),
                              onTap: () => _handleExtIPRefresh(context),
                            ),
                          ],
                        ),
                      ],
                    );

                    return ListView(
                      children: widgets,
                    );
                  },
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
