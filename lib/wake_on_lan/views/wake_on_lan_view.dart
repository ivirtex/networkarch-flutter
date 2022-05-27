// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/utils.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';

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

  bool _shouldSendButtonBeActive = false;

  final _listKey = GlobalKey<AnimatedListState>();

  late final AnimatedListModel<WolResponseModel> wolResponses;

  @override
  void initState() {
    super.initState();

    wolResponses = AnimatedListModel(
      listKey: _listKey,
      removedItemBuilder: _buildItem,
    );

    if (kDebugMode) {
      ipv4TextFieldController.text = '192.168.0.99';
      macTextFieldController.text = '2A:D8:BB:E3:33:D1';
    }
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

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wake on LAN'),
        actions: [
          TextButton(
            onPressed: _shouldSendButtonBeActive ? _handleSend : null,
            child: Text(
              'Send',
              style: TextStyle(
                color: _shouldSendButtonBeActive ? Colors.green : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  CupertinoPageScaffold _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Whois'),
            border: null,
            stretch: true,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _handleSend,
              child: Text(
                'Send',
                style: TextStyle(
                  color: CupertinoDynamicColor.resolve(
                    CupertinoColors.activeGreen,
                    context,
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ContentListView(
      children: [
        BlocConsumer<WakeOnLanBloc, WakeOnLanState>(
          listener: (context, state) {
            if (state is WakeOnLanIPValidationFailure) {
              _isValidIpv4 = false;
              _isValidMac = true;
            }

            if (state is WakeOnLanMACValidationFailure) {
              _isValidIpv4 = true;
              _isValidMac = false;
            }

            if (state is WakeOnLanIPandMACValidationFailure) {
              _isValidIpv4 = false;
              _isValidMac = false;
            }

            if (state is WakeOnLanSuccess) {
              _isValidIpv4 = true;
              _isValidMac = true;

              final WolResponseModel response = WolResponseModel(
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
                DomainTextField(
                  controller: ipv4TextFieldController,
                  label: 'IPv4 address',
                  errorText: _isValidIpv4 ? null : 'Invalid IPv4 address',
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    setState(() {
                      _shouldSendButtonBeActive = _areTextFieldsNotEmpty();
                    });
                  },
                ),
                const SizedBox(height: 10),
                DomainTextField(
                  controller: macTextFieldController,
                  label: 'MAC address [XX:XX:XX:XX:XX:XX]',
                  errorText: _isValidMac ? null : 'Invalid MAC address',
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    setState(() {
                      _shouldSendButtonBeActive = _areTextFieldsNotEmpty();
                    });
                  },
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
    );
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    WolResponseModel item,
  ) {
    return FadeTransition(
      opacity: animation.drive(wolResponses.fadeTween),
      child: SlideTransition(
        position: animation.drive(wolResponses.slideTween),
        child: DataCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: item.status == WolStatus.success
                ? const StatusCard(
                    color: Colors.green,
                    text: 'Success',
                  )
                : const StatusCard(
                    color: Colors.red,
                    text: 'Error',
                  ),
            title: Text(item.mac.address),
            subtitle: Text(item.ipv4.address),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => _handleCardTap(item),
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

    hideKeyboard(context);
  }

  void _handleCardTap(WolResponseModel response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WolPacketDetailsView(response),
      ),
    );
  }
}
