// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/netword_status.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class WifiStatusCard extends StatelessWidget {
  const WifiStatusCard({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function? onPressed;

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
                      ConnectionState(state),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Text('SSID'),
                      const Spacer(),
                      if (state is NetworkStatusUpdateSuccess)
                        Text(state.wifiInfo!.wifiIPv4 ?? 'N/A')
                      else
                        Expanded(child: const LinearProgressIndicator()),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onPressed as void Function()?,
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

class ConnectionState extends StatelessWidget {
  const ConnectionState(this.state, {Key? key}) : super(key: key);

  final NetworkStatusState state;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20.0;

    if (state is NetworkStatusUpdateSuccess ||
        state is NetworkStatusUpdateWithExtIPSuccess) {
      final isNetworkConnected = state.wifiInfo!.wifiIPv4 != null;
      return Row(
        children: [
          Text(
            isNetworkConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: isNetworkConnected ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(width: 5.0),
          Icon(
            isNetworkConnected ? Icons.check_circle : Icons.cancel,
            size: iconSize,
            color: isNetworkConnected ? Colors.green : Colors.red,
          ),
        ],
      );
    } else if (state is NetworkStatusUpdateFailure) {
      return Row(
        children: const [
          Text(
            'Error',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 5.0),
          Icon(
            Icons.cancel,
            size: iconSize,
          ),
        ],
      );
    } else {
      return Row(
        children: const [
          Text(
            'Checking connection...',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 5.0),
          SizedBox(
            height: 10.0,
            width: 10.0,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      );
    }
  }
}
