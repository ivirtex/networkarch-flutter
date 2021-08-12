// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/services/utils/network_type.dart';
import 'package:network_arch/services/widgets/drawer.dart';
import 'package:network_arch/services/widgets/shared_widgets.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void _showSnackbar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final permissions = Provider.of<PermissionsModel>(context, listen: false);

      await permissions.initPrefs();

      Permission.location.isGranted.then((bool isGranted) {
        if (isGranted) {
          permissions.isLocationPermissionGranted = true;
        } else if (!isGranted &&
            (permissions.prefs!
                    .getBool('hasLocationPermissionsBeenRequested') ??
                false)) {
          Future.delayed(Duration.zero, () {
            _showSnackbar(Constants.permissionDeniedSnackBar);
          });
        } else {
          Navigator.of(context).pushReplacementNamed('/permissions');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                stream: context.read<ConnectivityModel>().getWifiInfoStream,
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
                      final model = context.read<LanScannerModel>();

                      model.configure(ip: snapshot.data!.wifiIP);
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
                stream: context.read<ConnectivityModel>().getCellularInfoStream,
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
              // ToolCard(
              //   toolName: 'LAN Scanner',
              //   toolDesc: Constants.lanScannerDesc,
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/tools/lan');
              //   },
              // ),
              ToolCard(
                toolName: 'Wake On LAN',
                toolDesc: Constants.wolDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/wol');
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
