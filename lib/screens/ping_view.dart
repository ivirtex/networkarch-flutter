// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_arch/utils/keyboard_hider.dart';
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
  IconData pingButtonIcon = FontAwesomeIcons.play;
  Color pingButtonColor = Colors.green;

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
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: targetHostController,
                    autocorrect: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: "IP address",
                        labelStyle: TextStyle()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: FaIcon(pingButtonIcon, color: pingButtonColor),
                    onPressed: () {
                      if (pingButtonIcon == FontAwesomeIcons.play) {
                        setState(() {
                          pingButtonIcon = FontAwesomeIcons.times;
                          pingButtonColor = Colors.red;
                        });
                        pingModel.clearData();
                        pingModel.isPingingStarted = true;
                        pingModel.setHost(targetHostController.text);
                      } else {
                        setState(() {
                          pingButtonIcon = FontAwesomeIcons.play;
                          pingButtonColor = Colors.green;
                        });
                        pingModel.stopStream();
                        pingModel.isPingingStarted = false;
                      }

                      targetHostController.clear();
                      hideKeyboard(context);
                    },
                  ),
                )
              ],
            ).padding(all: 10),
            Consumer<PingModel>(
              builder: (context, model, child) {
                if (model.isPingingStarted) {
                  return StreamBuilder(
                    stream: pingModel.getStream(),
                    initialData: null,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        model.pingData.add(snapshot.data);

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: model.pingData.length,
                          itemBuilder: (context, index) {
                            PingData currData = model.pingData[index];

                            if (currData.error != null) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ListTile(
                                    leading: FaIcon(
                                      FontAwesomeIcons.timesCircle,
                                      color: Colors.red,
                                    ),
                                    title: Text(model
                                        .getErrorDesc(currData.error.error)),
                                  ),
                                ),
                              );
                            }

                            if (currData.response != null) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ListTile(
                                    title: Text(currData.response.ip),
                                    subtitle: Row(
                                      children: [
                                        Text(currData.response.seq.toString()),
                                        Text(currData.response.ttl.toString())
                                      ],
                                    ),
                                    trailing: Text(
                                      currData.response.time.inMilliseconds
                                              .toString() +
                                          " ms",
                                    ),
                                  ),
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
