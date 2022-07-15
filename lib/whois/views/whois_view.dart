// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/theme/theme.dart';
import 'package:network_arch/utils/utils.dart';
import 'package:network_arch/whois/whois.dart';

class WhoisView extends StatefulWidget {
  const WhoisView({super.key});

  @override
  State<WhoisView> createState() => _WhoisViewState();
}

class _WhoisViewState extends State<WhoisView> {
  final _targetHostController = TextEditingController();
  String get _target => _targetHostController.text;

  bool _shouldCheckButtonBeActive = false;
  bool _isPremiumAvail = true;

  @override
  void initState() {
    super.initState();

    _isPremiumAvail = isPremiumActive();
  }

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
      body: _buildBody(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Whois'),
      navBarTrailingWidget: CupertinoButton(
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
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return ContentListView(
      usePaddingOniOS: true,
      children: [
        DomainTextField(
          controller: _targetHostController,
          onChanged: (_) {
            setState(() {
              _shouldCheckButtonBeActive =
                  _target.isNotEmpty && _isPremiumAvail;
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
                    child: Text(
                      state.response,
                      style: TextStyle(
                        color: isIOS
                            ? Themes.iOStextColor.resolveFrom(context)
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (state is WhoisLoadInProgress) {
              return const LoadingCard();
            }

            if (state is WhoisLoadFailure) {
              return const ErrorCard(
                message: Constants.defaultError,
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
      Hive.box<bool>('iap').put('isPremiumTempGranted', false);

      _isPremiumAvail = isPremiumActive();
    });

    context.read<WhoisBloc>().add(WhoisRequested(domain: _target));

    hideKeyboard(context);
  }
}
