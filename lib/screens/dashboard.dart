// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/models/toast_notification_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<ToastNotificationModel>().fToast.init(context);

    final permissions = context.read<PermissionsModel>();

    Future.microtask(
      () async => {
        await permissions.initPrefs(),
      },
    ).whenComplete(
      () => {
        Permission.location.isGranted.then((bool isGranted) {
          if (isGranted) {
            permissions.isLocationPermissionGranted = true;
          } else if (!isGranted &&
              (permissions.prefs!
                      .getBool('hasLocationPermissionsBeenRequested') ??
                  false)) {
            Future.delayed(
              Duration.zero,
              () {
                Constants.showToast(
                  context.read<ToastNotificationModel>().fToast,
                  Constants.permissionDeniedToast,
                );
              },
            );
          } else {
            Navigator.of(context).pushReplacementNamed('/permissions');
          }
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  SingleChildScrollView _buildAndroid(BuildContext context) {
    return SingleChildScrollView(
      child: _buildBody(context),
    );
  }

  CupertinoPageScaffold _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text(
              'Dashboard',
            ),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: context.read<ConnectivityModel>().getWifiInfoStream,
                initialData: null,
                builder:
                    (context, AsyncSnapshot<SynchronousWifiInfo?> snapshot) {
                  // print('reloading wifi data');

                  if (snapshot.hasError) {
                    return const NetworkCard(
                      networkType: NetworkType.wifi,
                      snapshotHasError: true,
                      firstLine: Text('N/A'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const NetworkCard(
                      networkType: NetworkType.wifi,
                      firstLine: Text('N/A'),
                    );
                  } else {
                    final bool isWifiConnected =
                        snapshot.data!.wifiIPv4 != null;

                    return NetworkCard(
                      isNetworkConnected: isWifiConnected,
                      networkType: NetworkType.wifi,
                      firstLine: Text(snapshot.data!.wifiSSID ?? 'N/A'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/wifi');
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
                  Navigator.pushNamed(context, '/tools/ping', arguments: '');
                },
              ),
              SizedBox(
                height: Constants.listSpacing,
              ),
              ToolCard(
                toolName: 'LAN Scanner',
                toolDesc: Constants.lanScannerDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/lan');
                },
              ),
              SizedBox(
                height: Constants.listSpacing,
              ),
              ToolCard(
                toolName: 'Wake On LAN',
                toolDesc: Constants.wolDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/wol');
                },
              ),
              SizedBox(
                height: Constants.listSpacing,
              ),
              ToolCard(
                toolName: 'IP Geolocation',
                toolDesc: Constants.ipGeoDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/ip_geo');
                },
              ),
              SizedBox(
                height: Constants.listSpacing,
              ),
              ToolCard(
                toolName: 'Whois',
                toolDesc: Constants.whoisDesc,
                onPressed: () {
                  // TODO: Implement onTap()

                  Constants.showToast(
                    context.read<ToastNotificationModel>().fToast,
                    Constants.permissionGrantedToast,
                  );
                },
              ),
              SizedBox(
                height: Constants.listSpacing,
              ),
              ToolCard(
                toolName: 'DNS Lookup',
                toolDesc: Constants.dnsDesc,
                onPressed: () {
                  // TODO: Implement onTap()

                  Constants.showToast(
                    context.read<ToastNotificationModel>().fToast,
                    Constants.permissionDeniedToast,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
