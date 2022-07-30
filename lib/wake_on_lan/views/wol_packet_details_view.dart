// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';

class WolPacketDetailsView extends StatelessWidget {
  const WolPacketDetailsView(this.response, {super.key});

  final WolResponseModel response;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packet details'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Packet details'),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => ContentListView(
        children: [
          RoundedList(
            children: [
              ListTextLine(
                widgetL: const Text('MAC address'),
                widgetR: Text(response.mac.address),
              ),
              ListTextLine(
                widgetL: const Text('IP address'),
                widgetR: Text(response.ipv4.address),
              ),
              HexBytesViewer(
                title: 'Magic packet bytes',
                bytes: response.packetBytes,
              ),
            ],
          ),
        ],
      ),
      iosBuilder: (_) => ContentListView(
        children: [
          RoundedList(
            children: [
              ListTextLine(
                widgetL: const Text('MAC address'),
                widgetR: Text(response.mac.address),
              ),
              ListTextLine(
                widgetL: const Text('IP address'),
                widgetR: Text(response.ipv4.address),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Text('Magic packet bytes'),
            children: [
              HexBytesViewer(
                bytes: response.packetBytes,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
