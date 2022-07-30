// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_tools/network_tools.dart';

// Project imports:
import 'package:network_arch/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:network_arch/lan_scanner/widgets/host_card.dart';
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/shared/shared.dart';

class LanScannerView extends StatefulWidget {
  const LanScannerView({super.key});

  @override
  _LanScannerViewState createState() => _LanScannerViewState();
}

class _LanScannerViewState extends State<LanScannerView> {
  final _appBarKey = GlobalKey<ActionAppBarState>();
  final _listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListModel<ActiveHost> _hosts;
  late final LanScannerBloc _bloc;

  @override
  void initState() {
    super.initState();

    _hosts =
        AnimatedListModel(listKey: _listKey, removedItemBuilder: _buildItem);
    _bloc = context.read<LanScannerBloc>();
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.add(LanScannerStopped());
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
      appBar: ActionAppBar(
        title: 'LAN Scanner',
        isActive: true,
        onStartPressed: _handleStart,
        onStopPressed: _handleStop,
        key: _appBarKey,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Lan Scanner'),
      navBarTrailingWidget: BlocBuilder<LanScannerBloc, LanScannerState>(
        builder: (context, state) {
          return state is LanScannerRunStart ||
                  state is LanScannerRunProgressUpdate
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _handleStop,
                  child: const Text('Stop'),
                )
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _handleStart,
                  child: const Text('Start'),
                );
        },
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ContentListView(
      children: [
        BlocListener<LanScannerBloc, LanScannerState>(
          listener: (context, state) {
            if (state is LanScannerRunProgressUpdate) {
              _appBarKey.currentState!.setState(() {
                _appBarKey.currentState!.progress = state.progress / 100;
              });
            }

            if (state is LanScannerRunComplete) {
              _appBarKey.currentState!.toggleAnimation();
            }

            if (state is LanScannerRunNewHost) {
              _hosts.insert(_hosts.length, state.host);
            }
          },
          child: AnimatedList(
            key: _listKey,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            initialItemCount: _hosts.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(
                context,
                animation,
                _hosts[index],
              );
            },
          ),
        ),
      ],
    );
  }

  FadeTransition _buildItem(
    BuildContext context,
    Animation<double> animation,
    ActiveHost item,
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
    _appBarKey.currentState!.setState(() {
      _appBarKey.currentState!.progress = null;
    });

    if (!mounted) return;
    context.read<LanScannerBloc>().add(LanScannerStarted());
  }
}
