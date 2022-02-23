// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/bloc/bloc.dart';
import 'package:network_arch/network_status/views/views.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({Key? key}) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  @override
  void initState() {
    super.initState();

    Permission.location.isGranted.then((bool isGranted) {
      if (isGranted) {
        context.read<NetworkStatusBloc>().add(NetworkStatusStreamStarted());
        context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
      } else {
        Navigator.of(context).pushReplacementNamed('/permissions');
        // Constants.showPermissionDeniedNotification(context);
      }
    });
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
            largeTitle: Text('Overview'),
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
          padding: Constants.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WifiStatusCard(),
              const SizedBox(height: Constants.listSpacing),
              const CarrierStatusCard(),
              const Divider(indent: 15, endIndent: 15),
              ToolCard(
                toolName: 'Ping',
                toolDesc: Constants.pingDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/ping', arguments: '');
                },
              ),
              const SizedBox(height: Constants.listSpacing),
              ToolCard(
                toolName: 'LAN Scanner',
                toolDesc: Constants.lanScannerDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/lan');
                },
              ),
              const SizedBox(height: Constants.listSpacing),
              ToolCard(
                toolName: 'Wake On LAN',
                toolDesc: Constants.wolDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/wol');
                },
              ),
              const SizedBox(height: Constants.listSpacing),
              ToolCard(
                toolName: 'IP Geolocation',
                toolDesc: Constants.ipGeoDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/ip_geo');
                },
              ),
              const SizedBox(height: Constants.listSpacing),
              ToolCard(
                toolName: 'Whois',
                toolDesc: Constants.whoisDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/whois');
                },
              ),
              const SizedBox(height: Constants.listSpacing),
              ToolCard(
                toolName: 'DNS Lookup',
                toolDesc: Constants.dnsDesc,
                onPressed: () {
                  Navigator.pushNamed(context, '/tools/dns_lookup');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
