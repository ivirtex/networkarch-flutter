// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/dns_lookup/utils/rr_code_name.dart';
import 'package:network_arch/shared/platform_widget.dart';
import 'package:network_arch/utils/keyboard_hider.dart';

class DnsLookupView extends StatefulWidget {
  const DnsLookupView({Key? key}) : super(key: key);

  @override
  _DnsLookupViewState createState() => _DnsLookupViewState();
}

class _DnsLookupViewState extends State<DnsLookupView> {
  final _targetDomainController = TextEditingController();
  String get _target => _targetDomainController.text;

  final _dnsQueryTypeController = TextEditingController();
  String get _dnsQueryType => _dnsQueryTypeController.text;

  bool _shouldCheckButtonBeActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _targetDomainController.text = 'google.com';
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
        title: const Text('DNS Lookup'),
        actions: [
          TextButton(
            onPressed: _shouldCheckButtonBeActive ? _handleCheck : null,
            child: Text(
              'Check',
              style: TextStyle(
                color: _shouldCheckButtonBeActive ? Colors.green : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(child: _buildBody()),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('DNS Lookup'),
              trailing: CupertinoButton(
                onPressed: _handleCheck,
                child: const Text('Check'),
              ),
            ),
          ];
        },
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: Constants.bodyPadding,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: PlatformWidget(
                  androidBuilder: (context) {
                    return TextField(
                      autocorrect: false,
                      controller: _targetDomainController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Domain name',
                      ),
                      onChanged: (_) {
                        setState(() {
                          _shouldCheckButtonBeActive = _target.isNotEmpty;
                        });
                      },
                    );
                  },
                  iosBuilder: (context) {
                    return CupertinoTextField(
                      autocorrect: false,
                      controller: _targetDomainController,
                      placeholder: 'Domain name',
                      onChanged: (_) {
                        setState(() {
                          _shouldCheckButtonBeActive = _target.isNotEmpty;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: PlatformWidget(
                  androidBuilder: (context) {
                    return TextField(
                      autocorrect: false,
                      controller: _dnsQueryTypeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return _buildBottomSheet();
                              },
                            );
                          },
                        ),
                        labelText: 'Type',
                      ),
                    );
                  },
                  iosBuilder: (context) {
                    return CupertinoTextField(
                      autocorrect: false,
                      controller: _dnsQueryTypeController,
                      placeholder: 'Type',
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.listSpacing),
          BlocBuilder<DnsLookupBloc, DnsLookupState>(
            builder: (context, state) {
              return Container();
            },
          ),
        ],
      ),
    );
  }

  void _handleCheck() {
    final queryType = EnumToString.fromString(rrCodeName.values, _dnsQueryType);
    final queryCode = nameToRrCode(queryType!);

    context
        .read<DnsLookupBloc>()
        .add(DnsLookupRequested(hostname: _target, type: queryCode));

    hideKeyboard(context);
  }

  Widget _buildBottomSheet() {
    return ListView.builder(
      itemCount: rrCodeName.values.length,
      itemBuilder: (context, index) {
        final queryType = rrCodeName.values[index];

        return ListTile(
          title: Text(queryType.name),
          onTap: () {
            _dnsQueryTypeController.text = queryType.name;

            Navigator.pop(context);
          },
        );
      },
    );
  }
}
