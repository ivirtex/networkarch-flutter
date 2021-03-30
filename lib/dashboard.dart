import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data_card.dart';
import 'data_line.dart';
import 'drawer.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;

    bool isConnected = true;

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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              isConnected ? "Connected" : "Not connected",
                              style: TextStyle(
                                color: isConnected ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            FaIcon(
                              isConnected
                                  ? FontAwesomeIcons.checkCircle
                                  : FontAwesomeIcons.timesCircle,
                              color: isConnected ? Colors.green : Colors.red,
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Column(
                      children: [
                        DataLine(textL: "IP Address", textR: "192.168.0.1"),
                        DataLine(textL: "BSSID", textR: "UPC2137420")
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
