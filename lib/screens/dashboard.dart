import 'package:flutter/material.dart';
import 'package:network_arch/constants.dart';

import 'builders.dart';
import 'data_card.dart';
import 'data_line.dart';
import 'drawer.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;

    bool isWiFiConnected = true;
    bool isCellularConnected = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      drawer: DrawerWidget(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataCard(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                cardChild: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Wi-Fi",
                          style: Constants.networkTypeTextStyle,
                        ),
                        Spacer(),
                        Builders.buildConnectionState(isWiFiConnected)
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Column(
                      children: [
                        DataLine(
                          textL: "BSSID",
                          textR: "UPC2137420",
                        ),
                        DataLine(
                          textL: "Int. IP Address",
                          textR: "192.168.0.1",
                        ),
                      ],
                    )
                  ],
                ),
              ),
              DataCard(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                cardChild: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Cellular",
                          style: Constants.networkTypeTextStyle,
                        ),
                        Spacer(),
                        Builders.buildConnectionState(isCellularConnected)
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Column(
                      children: [
                        DataLine(textL: "Carrier", textR: "Play"),
                        DataLine(textL: "IP Address", textR: "192.168.0.1"),
                      ],
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
