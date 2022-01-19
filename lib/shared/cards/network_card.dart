// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class NetworkCard extends StatelessWidget {
  const NetworkCard({
    required this.networkType,
    required this.firstLine,
    this.isNetworkConnected,
    this.onPressed,
    this.snapshotHasError,
    Key? key,
  }) : super(key: key);

  final bool? isNetworkConnected;
  final NetworkType networkType;
  final Widget firstLine;
  final bool? snapshotHasError;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      margin: EdgeInsetsDirectional.zero,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                networkType == NetworkType.wifi ? 'Wi-Fi' : 'Cellular',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: isDarkModeOn ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              _buildConnectionState(
                isNetworkConnected: isNetworkConnected,
                snapshotHasError: snapshotHasError,
              )
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Text(networkType == NetworkType.wifi ? 'SSID' : 'Carrier'),
              const Spacer(),
              firstLine,
            ],
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Row _buildConnectionState({
  required bool? isNetworkConnected,
  required bool? snapshotHasError,
}) {
  const double iconSize = 20.0;

  if (isNetworkConnected != null) {
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
        )
      ],
    );
  } else if (snapshotHasError != null) {
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
        )
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
        )
      ],
    );
  }
}
