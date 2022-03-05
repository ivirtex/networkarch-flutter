// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/keyboard_hider.dart';
import 'package:network_arch/whois/whois.dart';

class WhoisView extends StatefulWidget {
  const WhoisView({Key? key}) : super(key: key);

  @override
  State<WhoisView> createState() => _WhoisViewState();
}

class _WhoisViewState extends State<WhoisView> {
  final _targetHostController = TextEditingController();
  String get _target => _targetHostController.text;

  bool _shouldCheckButtonBeActive = false;

  @override
  void dispose() {
    super.dispose();

    _targetHostController.dispose();
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
        title: const Text('Whois'),
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
              largeTitle: const Text('Whois'),
              border: null,
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
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
    return ContentListView(
      children: [
        DomainTextField(
          controller: _targetHostController,
          label: 'Domain name',
          onChanged: (_) {
            setState(() {
              _shouldCheckButtonBeActive = _target.isNotEmpty;
            });
          },
        ),
        const SizedBox(height: Constants.listSpacing),
        BlocBuilder<WhoisBloc, WhoisState>(
          builder: (context, state) {
            if (state is WhoisLoadSuccess) {
              return SlideInUp(
                child: FadeIn(
                  child: DataCard(
                    child: Text(state.response),
                  ),
                ),
              );
            }

            if (state is WhoisLoadInProgress) {
              return const LoadingCard();
            }

            if (state is WhoisLoadFailure) {
              return const ErrorCard(message: 'Failed to load data');
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  void _handleCheck() {
    context.read<WhoisBloc>().add(WhoisRequested(domain: _target));

    hideKeyboard(context);
  }
}
