// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
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
    return ContentListView(
      children: [
        BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
          builder: (context, state) {
            return state.status == NetworkStatus.success
                ? RoundedList(
                    children: [
                      ListTextLine(
                        textL: const Text('VoIP Support'),
                        textR:
                            Text(state.carrierInfo!.allowsVOIP ? 'Yes' : 'No'),
                      ),
                      ListTextLine(
                        textL: const Text('Carrier Name'),
                        textR: Text(state.carrierInfo!.carrierName ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('ISO Country Code'),
                        textR: Text(state.carrierInfo!.isoCountryCode ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Mobile Country Code'),
                        textR:
                            Text(state.carrierInfo!.mobileCountryCode ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Mobile Network Code'),
                        textR:
                            Text(state.carrierInfo!.mobileNetworkCode ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Network Generation'),
                        textR:
                            Text(state.carrierInfo!.networkGeneration ?? 'N/A'),
                      ),
                      ListTextLine(
                        textL: const Text('Radio Access Technology'),
                        textR: Text(state.carrierInfo!.radioType ?? 'N/A'),
                      ),
                    ],
                  )
                : const RoundedList(
                    children: [
                      ListTextLine(textL: Text('VoIP Support')),
                      ListTextLine(textL: Text('Carrier Name')),
                      ListTextLine(textL: Text('ISO Country Code')),
                      ListTextLine(textL: Text('Mobile Country Code')),
                      ListTextLine(textL: Text('Mobile Network Code')),
                      ListTextLine(textL: Text('Network Generation')),
                      ListTextLine(textL: Text('Radio Access Technology')),
                    ],
                  );
          },
        ),
      ],
    );
  }
}
