// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/utils/network_type.dart';
import 'package:network_arch/widgets/builders.dart';
import 'package:network_arch/widgets/cards/data_card.dart';
import 'package:network_arch/widgets/data_line.dart';

class NetworkCard extends StatelessWidget {
  const NetworkCard({
    Key key,
    this.isDarkTheme,
    this.isNetworkConnected,
    this.networkType,
    this.firstLine,
    this.onPressed,
  }) : super(key: key);

  final bool isDarkTheme;
  final bool isNetworkConnected;
  final NetworkType networkType;
  final String firstLine;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      color: isDarkTheme ? Colors.grey[800] : Colors.grey[200],
      cardChild: Column(
        children: [
          Row(
            children: [
              Text(
                networkType == NetworkType.wifi ? "Wi-Fi" : "Cellular",
                style: Constants.networkTypeTextStyle,
              ),
              Spacer(),
              Builders.buildConnectionState(isNetworkConnected)
            ],
          ),
          SizedBox(height: 5.0),
          Column(
            children: [
              DataLine(
                textL: networkType == NetworkType.wifi ? "SSID" : "Carrier",
                textR: firstLine,
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  primary: isDarkTheme ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  backgroundColor:
                      isDarkTheme ? Colors.grey[700] : Colors.grey[300],
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        "Detailed view",
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
