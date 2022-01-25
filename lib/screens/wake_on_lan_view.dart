// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/models/toast_notification_model.dart';
import 'package:network_arch/models/wake_on_lan_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class WakeOnLanView extends StatefulWidget {
  const WakeOnLanView({Key? key}) : super(key: key);

  @override
  _WakeOnLanViewState createState() => _WakeOnLanViewState();
}

class _WakeOnLanViewState extends State<WakeOnLanView> {
  final ipv4TextFieldController = TextEditingController();
  final macTextFieldController = TextEditingController();

  final _listKey = GlobalKey<AnimatedListState>();

  bool areTextFieldsNotEmpty() {
    return ipv4TextFieldController.text.isNotEmpty &&
        macTextFieldController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    context.read<WakeOnLanModel>().wolResponses = AnimatedListModel(
      listKey: _listKey,
      removedItemBuilder: _buildItem,
    );
  }

  @override
  void dispose() {
    super.dispose();

    ipv4TextFieldController.dispose();
    macTextFieldController.dispose();
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    WolResponse? item,
  ) {
    final model = context.read<WakeOnLanModel>();

    return FadeTransition(
      opacity: animation.drive(model.wolResponses.fadeTween),
      child: SlideTransition(
        position: animation.drive(model.wolResponses.slideTween),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            leading: item!.status == WolStatus.success
                ? const StatusCard(text: 'Success', color: Colors.green)
                : const StatusCard(text: 'Fail', color: Colors.red),
            title: Text('IP: ${item.ipv4}'),
            subtitle: Text('MAC: ${item.mac}'),
            trailing: TextButton(
              onPressed: item.status == WolStatus.success
                  ? () {
                      Navigator.popAndPushNamed(
                        context,
                        '/tools/ping',
                        arguments: item.ipv4,
                      );
                    }
                  : null,
              child: const Text('Ping address'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Wake on LAN'),
            iconTheme: Theme.of(context).iconTheme,
            titleTextStyle: Theme.of(context).textTheme.headline6,
            actions: [
              TextButton(
                onPressed: !areTextFieldsNotEmpty()
                    ? null
                    : () async {
                        final model = context.read<WakeOnLanModel>();

                        model.ipv4 = ipv4TextFieldController.text;
                        model.mac = macTextFieldController.text;

                        if (model.areTextFieldsValid()) {
                          await model.sendPacket();
                        } else {
                          Constants.showToast(
                            context.read<ToastNotificationModel>().fToast,
                            Constants.wolValidationFault,
                          );
                        }
                      },
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: areTextFieldsNotEmpty() ? Colors.green : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: _buildBody(context),
          ),
        );
      },
      iosBuilder: (context) {
        return CupertinoPageScaffold(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const CupertinoSliverNavigationBar(
                stretch: true,
                border: null,
                largeTitle: Text(
                  'Wake On LAN',
                ),
              )
            ],
            body: _buildBody(context),
          ),
        );
      },
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: ipv4TextFieldController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'IPv4 address',
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          TextField(
            autocorrect: false,
            controller: macTextFieldController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'MAC address [XX:XX:XX:XX:XX:XX]',
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            // initialItemCount: context.read<LanScannerModel>().hosts.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(
                context,
                animation,
                context.read<WakeOnLanModel>().wolResponses[index],
              );
            },
          )
        ],
      ),
    );
  }
}
