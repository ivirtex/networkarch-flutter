// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:lan_scanner/lan_scanner.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';

//! Not really working yet.
class LanScannerView extends StatefulWidget {
  const LanScannerView({Key? key}) : super(key: key);

  @override
  _LanScannerViewState createState() => _LanScannerViewState();
}

class _LanScannerViewState extends State<LanScannerView> {
  @override
  Widget build(BuildContext context) {
    final LanScannerModel lanModel =
        Provider.of<LanScannerModel>(context, listen: false);

    return Scaffold(
      appBar: context.watch<LanScannerModel>().getIsScannerRunning()
          ? Builders.switchableAppBar(
              context: context,
              title: 'LAN Scanner',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: () {
                setState(() {
                  lanModel.isScannerViewActive = false;
                });
              },
            )
          : Builders.switchableAppBar(
              context: context,
              title: 'LAN Scanner',
              action: ButtonActions.start,
              isActive: true,
              onPressed: () {
                lanModel.isScannerViewActive = true;

                setState(() {
                  lanModel.hosts.clear();
                });
              },
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              value: context.watch<LanScannerModel>().scanProgress,
            ),
          ),
          Visibility(
            visible: context.read<LanScannerModel>().isScannerViewActive,
            child: StreamBuilder(
              stream: context.read<LanScannerModel>().getStream(),
              initialData: null,
              builder:
                  (BuildContext context, AsyncSnapshot<HostModel?> snapshot) {
                if (snapshot.hasError) {
                  // print(snapshot.error);
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  lanModel.isScannerViewActive = false;
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print('Received new data: ${snapshot.data!.ip}');

                  context.read<LanScannerModel>().hosts.add(snapshot.data!);

                  return buildHostsListView(context.read<LanScannerModel>());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Padding buildHostsListView(LanScannerModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.hosts.length,
        itemBuilder: (context, index) {
          final HostModel currData = model.hosts.elementAt(index);

          return Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              leading: const StatusCard(
                color: Colors.greenAccent,
                text: 'Online',
              ),
              title: Text(currData.ip),
            ),
          );
        },
      ),
    );
  }
}
