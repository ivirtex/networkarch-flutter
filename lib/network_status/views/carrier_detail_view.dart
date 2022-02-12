// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared.dart';

class CarrierDetailView extends StatelessWidget {
  const CarrierDetailView({Key? key}) : super(key: key);

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
              'Carrier Details',
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
          'Carrier Details',
        ),
      ),
      body: _buildDataList(context),
    );
  }

  Widget _buildDataList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.bodyPadding),
      child: BlocBuilder<NetworkStateBloc, NetworkState>(
        builder: (context, state) {
          if (state.status == NetworkStatus.success) {
            return RoundedList(
              children: [
                DataLine(
                  textL: const Text('VoIP Support'),
                  textR: Text(state.carrierInfo!.allowsVOIP ? 'Yes' : 'No'),
                ),
                DataLine(
                  textL: const Text('Carrier Name'),
                  textR: Text(state.carrierInfo!.carrierName ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('ISO Country Code'),
                  textR: Text(state.carrierInfo!.isoCountryCode ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Mobile Country Code'),
                  textR: Text(state.carrierInfo!.mobileCountryCode ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Mobile Network Code'),
                  textR: Text(state.carrierInfo!.mobileNetworkCode ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Network Generation'),
                  textR: Text(state.carrierInfo!.networkGeneration ?? 'N/A'),
                ),
                DataLine(
                  textL: const Text('Radio Access Technology'),
                  textR: Text(state.carrierInfo!.radioType ?? 'N/A'),
                ),
              ],
            );
          } else {
            // ignore: prefer_const_constructors
            return RoundedList(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const DataLine(
                  textL: Text('VoIP Support'),
                ),
                const DataLine(
                  textL: Text('Carrier Name'),
                ),
                const DataLine(
                  textL: Text('ISO Country Code'),
                ),
                const DataLine(
                  textL: Text('Mobile Country Code'),
                ),
                const DataLine(
                  textL: Text('Mobile Network Code'),
                ),
                const DataLine(
                  textL: Text('Network Generation'),
                ),
                const DataLine(
                  textL: Text('Radio Access Technology'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
