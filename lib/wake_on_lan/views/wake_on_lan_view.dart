import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_arch/wake_on_lan/bloc/wake_on_lan_bloc.dart';
import 'package:network_arch/wake_on_lan/models/wol_response_model.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class WakeOnLanView extends StatefulWidget {
  const WakeOnLanView({Key? key}) : super(key: key);

  @override
  _WakeOnLanViewState createState() => _WakeOnLanViewState();
}

class _WakeOnLanViewState extends State<WakeOnLanView> {
  final ipv4TextFieldController = TextEditingController();
  bool _isValidIpv4 = true;

  final macTextFieldController = TextEditingController();
  bool _isValidMac = true;

  String get ipv4 => ipv4TextFieldController.text;
  String get mac => macTextFieldController.text;

  final _listKey = GlobalKey<AnimatedListState>();

  late final AnimatedListModel<WolResponse> wolResponses;

  @override
  void initState() {
    super.initState();

    wolResponses = AnimatedListModel(
      listKey: _listKey,
      removedItemBuilder: _buildItem,
    );

    //! debug
    ipv4TextFieldController.text = '192.168.0.100';
    macTextFieldController.text = '2A:D8:BB:E3:33:D1';
  }

  @override
  void dispose() {
    super.dispose();

    ipv4TextFieldController.dispose();
    macTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
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
              'Wake On LAN',
            ),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wake on LAN'),
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          TextButton(
            onPressed: !_areTextFieldsNotEmpty() ? null : _handleSend,
            child: Text(
              'Send',
              style: TextStyle(
                color: _areTextFieldsNotEmpty() ? Colors.green : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          BlocConsumer<WakeOnLanBloc, WakeOnLanState>(
            listener: (context, state) {
              if (state is WakeOnLanIPValidationFailure) {
                _isValidIpv4 = false;
              }

              if (state is WakeOnLanMACValidationFailure) {
                _isValidMac = false;
              }

              if (state is WakeOnLanIPandMACValidationFailure) {
                _isValidIpv4 = false;
                _isValidMac = false;
              }

              if (state is WakeOnLanSuccess) {
                _isValidIpv4 = true;
                _isValidMac = true;

                final WolResponse response = WolResponse(
                  state.ipv4,
                  state.mac,
                  state.packetBytes,
                  WolStatus.success,
                );
                wolResponses.insert(wolResponses.length, response);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  PlatformWidget(
                    androidBuilder: (context) => TextField(
                      autocorrect: false,
                      controller: ipv4TextFieldController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'IPv4 address',
                        errorText: _isValidIpv4 ? null : 'Invalid IPv4 address',
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                    iosBuilder: (context) => CupertinoTextField(
                      autocorrect: false,
                      controller: ipv4TextFieldController,
                      keyboardType: TextInputType.number,
                      placeholder: 'IPv4 address',
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  PlatformWidget(
                    androidBuilder: (context) => TextField(
                      autocorrect: false,
                      controller: macTextFieldController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'MAC address [XX:XX:XX:XX:XX:XX]',
                        errorText: _isValidMac ? null : 'Invalid MAC address',
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                    iosBuilder: (context) => CupertinoTextField(
                      autocorrect: false,
                      controller: macTextFieldController,
                      keyboardType: TextInputType.number,
                      placeholder: 'MAC address [XX:XX:XX:XX:XX:XX]',
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          AnimatedList(
            key: _listKey,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            initialItemCount: wolResponses.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(
                context,
                animation,
                wolResponses[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    WolResponse? item,
  ) {
    return FadeTransition(
      opacity: animation.drive(wolResponses.fadeTween),
      child: SlideTransition(
        position: animation.drive(wolResponses.slideTween),
        child: DataCard(
          child: ExpansionTile(
            leading: item!.status == WolStatus.success
                ? const StatusCard(text: 'Success', color: Colors.green)
                : const StatusCard(text: 'Fail', color: Colors.red),
            title: Text(item.ipv4.address),
            subtitle: Text(item.mac.address),
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

  bool _areTextFieldsNotEmpty() {
    return ipv4TextFieldController.text.isNotEmpty &&
        macTextFieldController.text.isNotEmpty;
  }

  void _handleSend() {
    context.read<WakeOnLanBloc>().add(
          WakeOnLanRequested(
            ipv4: ipv4,
            macAddress: mac,
          ),
        );
  }
}
