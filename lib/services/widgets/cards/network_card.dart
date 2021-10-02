// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/services/utils/enums.dart';
import 'package:network_arch/services/widgets/cards/data_card.dart';

class NetworkCard extends StatelessWidget {
  const NetworkCard({
    Key? key,
    this.isNetworkConnected,
    required this.networkType,
    required this.firstLine,
    this.onPressed,
    this.snapshotHasError,
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
          const SizedBox(height: 5.0),
          Column(
            children: [
              const SizedBox(height: 10),
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
                  backgroundColor: isDarkModeOn
                      ? Platform.isAndroid
                          ? Constants.darkBtnColor
                          : Constants.iOSdarkBtnColor
                      : Platform.isAndroid
                          ? Constants.lightBtnColor
                          : Constants.iOSlightBtnColor,
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
              ),
            ],
          )
        ],
      ),
    );
  }
}

Row _buildConnectionState(
    {required bool? isNetworkConnected, required bool? snapshotHasError}) {
  if (isNetworkConnected != null) {
    return Row(
      children: [
        Text(
          isNetworkConnected ? 'Connected' : 'Disconnected',
          style: TextStyle(
            color: isNetworkConnected ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10.0),
        FaIcon(
          isNetworkConnected
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.timesCircle,
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
          ),
        ),
        SizedBox(width: 10.0),
        FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.red,
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
          ),
        ),
        SizedBox(width: 10.0),
        SizedBox(
          height: 20.0,
          width: 20.0,
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        )
      ],
    );
  }
}
