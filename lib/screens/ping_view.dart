// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import 'package:network_arch/models/ping_model.dart';

class PingView extends StatefulWidget {
  PingView({Key key}) : super(key: key);

  @override
  _PingViewState createState() => _PingViewState();
}

class _PingViewState extends State<PingView> {
  final targetHostController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PingModel pingModel = Provider.of<PingModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ping",
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
        actions: [
          TextButton(
            child: Text(
              "Start",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.grey[200],
              ),
            ),
            onPressed: () {
              setState(() {
                pingModel.clearData();
                pingModel.isPingingStarted = true;
                pingModel.setHost(targetHostController.text);
                targetHostController.clear();
              });

              print("pressed");
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            TextField(
              controller: targetHostController,
              autocorrect: false,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "IP address",
              ),
            ).padding(all: 10),
            Consumer<PingModel>(
              builder: (context, model, child) {
                print("rebuilded");

                if (model.isPingingStarted) {
                  return StreamBuilder(
                    stream: pingModel.getStream(), //! Can't listen twice
                    initialData: null,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        print("received snapshot");
                        model.pingData.add(snapshot.data);

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: model.pingData.length,
                          itemBuilder: (context, index) {
                            PingData currData = model.pingData[index];

                            if (currData.error != null) {
                              print(currData.error.toString());

                              return ListTile(
                                title: Text(currData.error.error.toString()),
                              );
                            }

                            if (currData.response != null) {
                              return ListTile(
                                leading: Text(currData.response.ip),
                                trailing: Text(
                                  currData.response.time.inMilliseconds
                                          .toString() +
                                      " ms",
                                ),
                              );
                            } else {
                              return null;
                            }
                          },
                        );

                        //! DEBUG
                        // return Text(snapshot.data.toString());
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
