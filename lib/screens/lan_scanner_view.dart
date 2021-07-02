// Flutter imports:
import 'package:flutter/material.dart';

import 'package:network_arch/widgets/builders.dart';

import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/widgets/shared_widgets.dart';
import 'package:network_tools/network_tools.dart';
import 'package:provider/provider.dart';

class LanScannerView extends StatefulWidget {
  const LanScannerView({Key? key}) : super(key: key);

  @override
  _LanScannerViewState createState() => _LanScannerViewState();
}

class _LanScannerViewState extends State<LanScannerView> {
  @override
  Widget build(BuildContext context) {
    LanScannerModel lanModel = Provider.of<LanScannerModel>(context);

    return Consumer<LanScannerModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: lanModel.isScannerRunning
              ? Builders.switchableAppBar(
                  context: context,
                  title: "LAN Scanner",
                  action: ButtonActions.start,
                  onPressed: null,
                )
              : Builders.switchableAppBar(
                  context: context,
                  title: "LAN Scanner",
                  action: ButtonActions.start,
                  onPressed: () {
                    setState(() {
                      lanModel.isScannerRunning = true;
                    });
                  },
                ),
          body: Consumer<LanScannerModel>(
            builder: (context, model, child) {
              if (model.isScannerRunning) {
                return StreamBuilder(
                  stream: model.getStream(),
                  initialData: null,
                  builder: (BuildContext context,
                      AsyncSnapshot<ActiveHost?> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }

                    if (!snapshot.hasData) {
                      return ErrorCard();
                    } else {
                      model.hosts.add(snapshot.data!);

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(
                              value: model.getProgress,
                              backgroundColor: Colors.grey,
                              color: Colors.green,
                            ),
                          ),
                          buildPingListView(model),
                        ],
                      );
                    }
                  },
                );
              } else {
                return buildPingListView(model);
              }
            },
          ),
        );
      },
    );
  }

  Padding buildPingListView(LanScannerModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: model.hosts.length,
        itemBuilder: (context, index) {
          ActiveHost currData = model.hosts.elementAt(index);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
                leading: StatusCard(
                  color: Colors.greenAccent,
                  text: "Online",
                ),
                title: Text(currData.ip)),
          );
        },
      ),
    );
  }
}
