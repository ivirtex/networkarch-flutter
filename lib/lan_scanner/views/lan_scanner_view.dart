// Dart imports:
// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';
import 'package:network_arch/lan_scanner/widgets/host_card.dart';
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/shared/action_app_bar.dart';
import 'package:network_arch/shared/cupertino_action_app_bar.dart';
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
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return BlocBuilder<LanScannerBloc, LanScannerState>(
      builder: (context, state) {
        if (state is LanScannerRunStarted ||
            state is LanScannerRunProgressUpdated) {
          return Scaffold(
            appBar: ActionAppBar(
              context,
              title: 'Lan Scanner',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: _handleStop,
            ),
            body: _buildBody(),
          );
        } else {
          return Scaffold(
            appBar: ActionAppBar(
              context,
              title: 'Lan Scanner',
              action: ButtonActions.start,
              isActive: true,
              onPressed: _handleStart,
            ),
            body: _buildBody(),
          );
        }
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          BlocBuilder<LanScannerBloc, LanScannerState>(
            builder: (context, state) {
              if (state is LanScannerRunStarted ||
                  state is LanScannerRunProgressUpdated) {
                return CupertinoActionAppBar(
                  context,
                  title: 'Ping',
                  action: ButtonActions.stop,
                  isActive: true,
                  onPressed: _handleStop,
                );
              } else {
                return CupertinoActionAppBar(
                  context,
                  title: 'Ping',
                  action: ButtonActions.start,
                  isActive: true,
                  onPressed: _handleStart,
                );
              }
            },
          )
        ],
        body: _buildBody(),
      ),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          BlocBuilder<LanScannerBloc, LanScannerState>(
            builder: (context, state) {
              if (state is LanScannerRunStarted) {
                final repository = context.read<LanScannerRepository>();

                repository.subscription = state.stream.listen((event) {
                  final host = InternetAddress(event.ip);

                  _hosts.insert(_hosts.length, host);
                });
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: LinearProgressIndicator(
                  // TODO: animate progress
                  value: state.progress,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
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
        child: HostCard(item: item),
      ),
    );
  }

  void _handleStop() {
    context.read<LanScannerBloc>().add(LanScannerStopped());
  }

  Future<void> _handleStart() async {
    await _hosts.removeAllElements(context);

    final bloc = context.read<LanScannerBloc>();
    bloc.add(
      LanScannerStarted(
        callback: (progress) {
          bloc.add(LanScannerProgressUpdated(progress));
        },
      ),
    );
    await Future.delayed(Duration.zero);
  }
}
