// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/utils/network_type.dart';
import 'package:network_arch/widgets/drawer.dart';
import 'package:network_arch/widgets/shared_widgets.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final ConnectivityModel connectivity =
        Provider.of<ConnectivityModel>(context);

    final LanScannerModel lanModel = Provider.of<LanScannerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
      ),
      drawer: const DrawerWidget(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: connectivity.getWifiInfoStream,
                initialData: null,
                builder:
                    (context, AsyncSnapshot<SynchronousWifiInfo?> snapshot) {
                  if (snapshot.hasError) {
                    return const ErrorCard(
                      message: Constants.defaultError,
                    );
                  }

                  if (!snapshot.hasData) {
                    return const LoadingCard();
                  } else {
                    final bool isWifiConnected = snapshot.data!.wifiIP != null;

                    if (isWifiConnected) {
                      lanModel.configure(ip: snapshot.data!.wifiIP);
                    }

                    return NetworkCard(
                      isNetworkConnected: isWifiConnected,
                      networkType: NetworkType.wifi,
                      firstLine: snapshot.data!.wifiName ?? 'N/A',
                      onPressed: () {
                        // TODO: Implement onTap()
                      },
                    );
                  }
                },
              ),
              StreamBuilder(
                stream: connectivity.getCellularInfoStream,
                initialData: null,
                builder:
                    (context, AsyncSnapshot<SynchronousCarrierInfo?> snapshot) {
                  if (snapshot.hasError) {
                    if (snapshot.error is NoSimCardException) {
                      return const ErrorCard(
                        message: Constants.simError,
                      );
                    } else {
                      return const ErrorCard(
                        message: Constants.defaultError,
                      );
                    }
                  }

                  if (!snapshot.hasData) {
                    return const LoadingCard();
                  } else {
                    final bool isCellularConnected =
                        snapshot.data!.carrierName != null;

                    return NetworkCard(
                      isNetworkConnected: isCellularConnected,
                      networkType: NetworkType.cellular,
                      firstLine: snapshot.data!.carrierName ?? 'N/A',
                      onPressed: () {
                        // TODO: Implement onTap()
                      },
                    );
                  }
                },
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
              ),
              ToolCard(
                toolName: 'Ping',
                toolDesc: Constants.pingDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/ping');
                },
              ),
              ToolCard(
                toolName: 'LAN Scanner',
                toolDesc: Constants.lanScannerDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/lan');
                },
              ),
              ToolCard(
                toolName: 'Wake On LAN',
                toolDesc: Constants.wolDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                toolName: 'IP Geolocation',
                toolDesc: Constants.ipGeoDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                toolName: 'Whois',
                toolDesc: Constants.whoisDesc,
                onPressed: () {
                  // TODO: Implement onTap()
                },
              ),
              ToolCard(
                toolName: 'DNS Lookup',
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
