// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared.dart';
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
      child: BlocBuilder<NetworkStateBloc, NetworkState>(
        builder: (context, state) {
          if (state.status == NetworkStatus.success) {
            return RoundedList(
              children: [
                DataLine(
                  textL: const Text('SSID'),
                  textR: Text(state.wifiInfo!.wifiSSID ?? 'N/A'),
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
                DataLine(
                  textL: const Text('External IP'),
                  textR: state.extIpStatus == ExtIpStatus.success
                      ? Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.only(right: 4),
                              iconSize: 16.0,
                              icon:
                                  const Icon(Icons.refresh, color: Colors.blue),
                              onPressed: () {
                                context
                                    .read<NetworkStateBloc>()
                                    .add(NetworkStateExtIPRequested());
                              },
                            ),
                            Text(state.extIP!),
                          ],
                        )
                      : const ListCircularProgressIndicator(),
                )
              ],
            );
          } else {
            // ignore: prefer_const_constructors
            return RoundedList(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const DataLine(
                  textL: Text('SSID'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('BSSID'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('Local IPv4'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('Local IPv6'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('Broadcast address'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('Gateway'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('Submask'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
                const DataLine(
                  textL: Text('External IP'),
                  textR: SizedBox(
                    width: Constants.linearProgressWidth,
                    child: ListCircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
