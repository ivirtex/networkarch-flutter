// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/services/utils/enums.dart';
import 'package:network_arch/services/widgets/builders.dart';
import 'package:network_arch/services/widgets/cards/data_card.dart';

class NetworkCard extends StatelessWidget {
  const NetworkCard({
    Key? key,
    required this.isNetworkConnected,
    required this.networkType,
    required this.firstLine,
    this.onPressed,
  }) : super(key: key);

  final bool isNetworkConnected;
  final NetworkType networkType;
  final String? firstLine;
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
              Builders.buildConnectionState(
                  isNetworkConnected: isNetworkConnected)
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
                  Text(firstLine ?? 'N/A'),
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
