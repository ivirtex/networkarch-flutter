// Flutter imports:
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/widgets/builders.dart';
import 'package:network_arch/widgets/shared_widgets.dart';

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

    return Consumer<LanScannerModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: lanModel.getIsScannerRunning()
              ? Builders.switchableAppBar(
                  context: context,
                  title: 'LAN Scanner',
                  action: ButtonActions.stop,
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
                  onPressed: () {
                    setState(() {
                      lanModel.hosts.clear();
                      lanModel.isScannerViewActive = true;
                    });
                  },
                ),
          body: Consumer<LanScannerModel>(
            builder: (context, model, child) {
              if (model.isScannerViewActive) {
                return StreamBuilder(
                  stream: model.getStream(),
                  initialData: null,
                  builder: (BuildContext context,
                      AsyncSnapshot<DeviceAddress?> snapshot) {
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
                      // print('Received new data: ${snapshot.data!.ip}');

                      model.hosts.add(snapshot.data!);

                      return buildHostsListView(model);
                    }
                  },
                );
              } else {
                return buildHostsListView(model);
              }
            },
          ),
        );
      },
    );
  }

  Padding buildHostsListView(LanScannerModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.hosts.length,
        itemBuilder: (context, index) {
          final DeviceAddress currData = model.hosts.elementAt(index);

          return Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
                leading: StatusCard(
                  color:
                      currData.exists ? Colors.greenAccent : Colors.redAccent,
                  text: currData.exists ? 'Online' : 'Offline',
                ),
                title: Text(currData.ip ?? 'N/A')),
          );
        },
      ),
    );
  }
}
