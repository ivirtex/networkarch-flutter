// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/dns_lookup/widgets/dns_record_card.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/utils.dart';

class DnsLookupView extends StatefulWidget {
  const DnsLookupView({Key? key}) : super(key: key);

  @override
  _DnsLookupViewState createState() => _DnsLookupViewState();
}

class _DnsLookupViewState extends State<DnsLookupView> {
  final _targetDomainController = TextEditingController();
  String get _target => _targetDomainController.text;

  rrCodeName _selectedDnsQueryType = rrCodeName.ANY;

  bool _shouldCheckButtonBeActive = false;
  bool _isPremiumAvail = true;

  @override
  void initState() {
    super.initState();

    _isPremiumAvail = isPremiumActive();
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
      body: _buildBody(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('DNS Lookup'),
              border: null,
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _handleCheck,
                child: Text(
                  'Check',
                  style: TextStyle(
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.activeGreen,
                      context,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ContentListView(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 3,
                child: DomainTextField(
                  label: 'Domain',
                  controller: _targetDomainController,
                  expands: true,
                  onChanged: (_) {
                    setState(() {
                      _shouldCheckButtonBeActive =
                          _target.isNotEmpty && _isPremiumAvail;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: DropdownButtonFormField<rrCodeName>(
                  items: _getQueryTypes(),
                  value: _selectedDnsQueryType,
                  hint: const Text('Type'),
                  icon: const Icon(Icons.arrow_downward_rounded),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  isExpanded: true,
                  onChanged: (type) {
                    setState(() {
                      _selectedDnsQueryType = type!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Constants.listSpacing),
        BlocBuilder<DnsLookupBloc, DnsLookupState>(
          builder: (context, state) {
            if (state is DnsLookupLoadInProgress) {
              return const LoadingCard();
            }

            if (state is DnsLookupLoadFailure) {
              return const ErrorCard(
                message: 'Failed to load data',
              );
            }

            if (state is DnsLookupLoadSuccess) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Found ${state.response.answer.length} records',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.listSpacing),
                  _buildRecords(state.response),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  void _handleCheck() {
    setState(() {
      Hive.box('iap').put('isPremiumTempGranted', false);

      _isPremiumAvail = isPremiumActive();
    });

    final queryCode = nameToRrCode(_selectedDnsQueryType);

    context
        .read<DnsLookupBloc>()
        .add(DnsLookupRequested(hostname: _target, type: queryCode));

    hideKeyboard(context);
  }

  List<DropdownMenuItem<rrCodeName>> _getQueryTypes() {
    return rrCodeName.values.map((type) {
      return DropdownMenuItem(
        value: type,
        child: Text(type.name),
      );
    }).toList();
  }

  Widget _buildRecords(DnsLookupResponse response) {
    return LiveList(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: response.answer.length,
      itemBuilder: (context, index, animation) {
        final record = response.answer[index];

        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.ease)).animate(animation),
            child: DnsRecordCard(record),
          ),
        );
      },
    );
  }
}
