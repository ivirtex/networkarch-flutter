// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/list_circular_progress_indicator.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class WifiStatusCard extends StatelessWidget {
  const WifiStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

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
                      Text(
                        'Wi-Fi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: isDarkModeOn ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      ConnectionStatus(
                        state,
                        connectionChecker: () =>
                            state.wifiInfo!.wifiIPv4 != null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Text('Local IP'),
                      const Spacer(),
                      if (state.status == NetworkStatus.success)
                        Text(state.wifiInfo!.wifiIPv4 ?? 'N/A')
                      else
                        const ListCircularProgressIndicator(),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/wifi');
            },
            style: TextButton.styleFrom(
              primary: isDarkModeOn ? Colors.white : Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              backgroundColor: Constants.getPlatformBtnColor(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  'Detailed view',
                  style: TextStyle(
                    color: isDarkModeOn ? Colors.white : Colors.black,
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowCircleRight,
                  color: isDarkModeOn ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
