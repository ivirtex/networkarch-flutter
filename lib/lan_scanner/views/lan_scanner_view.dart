// Dart imports:
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/shared/action_app_bar.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class LanScannerView extends StatefulWidget {
  const LanScannerView({Key? key}) : super(key: key);

  @override
  _LanScannerViewState createState() => _LanScannerViewState();
}

class _LanScannerViewState extends State<LanScannerView> {
  final _listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListModel<InternetAddress> _hosts;

  late double currProgress;

  @override
  void initState() {
    super.initState();

    _hosts =
        AnimatedListModel(listKey: _listKey, removedItemBuilder: _buildItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.watch<LanScannerBloc>().state is LanScannerRunStarted
          ? ActionAppBar(
              context,
              title: 'Lan Scanner',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: _handleStopPressed,
            )
          : ActionAppBar(
              context,
              title: 'Lan Scanner',
              action: ButtonActions.start,
              isActive: true,
              onPressed: _handleStartPressed,
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<LanScannerBloc, LanScannerState>(
              builder: (context, state) {
                return LinearProgressIndicator(
                  value: state.progress,
                );
              },
            ),
          ),
          AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            initialItemCount: _hosts.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(
                context,
                animation,
                _hosts[index],
              );
            },
          )
        ],
      ),
    );
  }

  FadeTransition _buildItem(
    BuildContext context,
    Animation<double> animation,
    InternetAddress item,
  ) {
    return FadeTransition(
      opacity: animation.drive(_hosts.fadeTween),
      child: SlideTransition(
        position: animation.drive(_hosts.slideTween),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            leading: const StatusCard(
              color: Colors.greenAccent,
              text: 'Online',
            ),
            title: Text(item.address),
            trailing: TextButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(
                  '/tools/ping',
                  arguments: item.address,
                );
              },
              child: const Text('Ping'),
            ),
          ),
        ),
      ),
    );
  }

  void _handleStopPressed() {
    context.read<LanScannerBloc>().add(LanScannerStopped(currProgress));
  }

  Future<void> _handleStartPressed() async {
    await _hosts.removeAllElements(context);

    context.read<LanScannerBloc>().add(LanScannerStarted(0.0));
    await Future.delayed(Duration.zero);
    //! hmm?

    final state = context.read<LanScannerBloc>().state;
    if (state is LanScannerRunStarted) {
      final repository = context.read<LanScannerRepository>();

      repository.subscription = state.stream.listen((event) {
        final host = InternetAddress(event.ip);

        _hosts.insert(_hosts.length, host);
      });
    }
  }
}
