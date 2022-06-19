// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/wake_on_lan/models/wol_response_model.dart';

class WolPacketDetailsView extends StatelessWidget {
  const WolPacketDetailsView(this.response, {Key? key}) : super(key: key);

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
    return ContentListView(
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
            // HexBytesViewer(
            //   title: 'Magic packet bytes',
            //   bytes: response.packetBytes,
            // ),
          ],
        ),
      ],
    );
  }
}
