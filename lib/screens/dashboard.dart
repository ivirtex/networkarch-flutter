import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:connectivity/connectivity.dart';

import 'package:network_arch/constants.dart';
import 'package:network_arch/utils/network_type.dart';
import 'package:network_arch/widgets/network_card.dart';
import 'package:network_arch/store/connection_type/connectivity_store.dart';
import 'package:network_arch/widgets/tool_card.dart';
import '../widgets/drawer.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ConnectivityStore connectivityStore = ConnectivityStore();

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
      ),
      drawer: DrawerWidget(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Observer(
                builder: (_) {
                  bool isWiFiConnected =
                      connectivityStore.connectivityStream.value ==
                              ConnectivityResult.wifi
                          ? true
                          : false;

                  return NetworkCard(
                    isDarkTheme: isDark,
                    isNetworkConnected: isWiFiConnected,
                    networkType: NetworkType.wifi,
                    bssidOrCarrier: "UPC2137420",
                    ipAddress: "192.168.0.1",
                    onPressed: () {
                      // TODO: Implement onTap()
                    },
                  );
                },
              ),
              Observer(
                builder: (_) {
                  bool isCellularConnected =
                      connectivityStore.connectivityStream.value ==
                              ConnectivityResult.mobile
                          ? true
                          : false;

                  return NetworkCard(
                    isDarkTheme: isDark,
                    isNetworkConnected: isCellularConnected,
                    networkType: NetworkType.cellular,
                    bssidOrCarrier: "papiez",
                    ipAddress: "0.0.0.0",
                    onPressed: () {
                      // TODO: Implement onTap()
                    },
                  );
                },
              ),
              Divider(
                indent: 15,
                endIndent: 15,
              ),

              //! debug
              // Observer(builder: (_) {
              //   return Text(connectivityStore.networkInterfaces.toString());
              // }),
              // TextButton(
              //   child: Text("update"),
              //   onPressed: () {
              //     connectivityStore.updateInterfaces();
              //   },
              // )

              ToolCard(
                isDarkTheme: isDark,
                toolName: "Ping",
                toolDesc: Constants.pingDesc,
                onPressed: () {
                  Navigator.pushNamed(context, "/tools/ping");
                },
              ),
              ToolCard(
                isDarkTheme: isDark,
                toolName: "LAN Scanner",
                toolDesc: Constants.lanScannerDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                isDarkTheme: isDark,
                toolName: "Wake On LAN",
                toolDesc: Constants.wolDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                isDarkTheme: isDark,
                toolName: "IP Geolocation",
                toolDesc: Constants.ipGeoDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                isDarkTheme: isDark,
                toolName: "Whois",
                toolDesc: Constants.whoisDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                isDarkTheme: isDark,
                toolName: "DNS Lookup",
                toolDesc: Constants.dnsDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
