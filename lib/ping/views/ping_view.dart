// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/keyboard_hider.dart';

class PingView extends StatefulWidget {
  const PingView({Key? key}) : super(key: key);

  @override
  _PingViewState createState() => _PingViewState();
}

class _PingViewState extends State<PingView> {
  final _appBarKey = GlobalKey<ActionAppBarState>();
  final _listKey = GlobalKey<AnimatedListState>();
  final _targetHostController = TextEditingController();
  late final AnimatedListModel<PingData?> _pingData;

  late String _targetHost;

  String get _target => _targetHostController.text;

  bool _shouldStartButtonBeActive = false;

  @override
  void initState() {
    super.initState();

    _pingData = AnimatedListModel<PingData>(
      listKey: _listKey,
      removedItemBuilder: _buildItem,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String routedAddr =
        // ignore: cast_nullable_to_non_nullable
        ModalRoute.of(context)!.settings.arguments as String;
    _targetHostController.text = routedAddr;
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
      appBar: ActionAppBar(
        title: 'Ping',
        isActive: true,
        onStartPressed: _handleStart,
        onStopPressed: _handleStop,
        key: _appBarKey,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          BlocBuilder<PingBloc, PingState>(
            builder: (context, state) {
              return state is PingRunNewData
                  ? CupertinoActionAppBar(
                      context,
                      title: 'Ping',
                      action: ButtonAction.stop,
                      isActive: _shouldStartButtonBeActive,
                      onPressed: _handleStop,
                    )
                  : CupertinoActionAppBar(
                      context,
                      title: 'Ping',
                      action: ButtonAction.start,
                      isActive: _shouldStartButtonBeActive,
                      onPressed: _handleStart,
                    );
            },
          ),
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ContentListView(
      children: [
        Row(
          children: [
            Expanded(
              child: BlocConsumer<PingBloc, PingState>(
                listener: (context, state) {
                  if (state is PingRunNewData) {
                    _pingData.insert(_pingData.length, state.pingData);

                    if (state.pingData.error != null &&
                        state.pingData.error?.error !=
                            ErrorType.RequestTimedOut) {
                      _appBarKey.currentState?.toggleAnimation();

                      context.read<PingBloc>().add(PingStopped());
                    }
                  }
                },
                builder: (context, state) {
                  return DomainTextField(
                    controller: _targetHostController,
                    label: 'IP address (e.g. 1.1.1.1)',
                    enabled: state is PingInitial || state is PingRunComplete,
                    onChanged: (_) {
                      setState(() {
                        _shouldStartButtonBeActive = _target.isNotEmpty;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 10.0),
            BlocBuilder<PingBloc, PingState>(
              builder: (context, state) {
                if (state is PingRunComplete && _pingData.isNotEmpty) {
                  return ClearListButton(
                    onPressed: () async {
                      await _pingData.removeAllElements(context);

                      setState(() {
                        _shouldStartButtonBeActive = _target.isNotEmpty;
                      });
                    },
                  );
                }

                return const ClearListButton();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedList(
          key: _listKey,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          initialItemCount: _pingData.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(
              context,
              animation,
              _pingData[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    PingData? item,
  ) {
    _targetHost = _targetHost.isEmpty ? 'N/A' : _targetHost;

    if (item!.error != null) {
      return FadeTransition(
        opacity: animation.drive(_pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(_pingData.slideTween),
          child: PingCard(
            list: _pingData,
            item: item,
            addr: _targetHost,
            hasError: true,
          ),
        ),
      );
    }

    if (item.response != null) {
      return FadeTransition(
        opacity: animation.drive(_pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(_pingData.slideTween),
          child: PingCard(
            list: _pingData,
            item: item,
            addr: _targetHost,
          ),
        ),
      );
    } else {
      throw Exception('Unexpected item type');
    }
  }

  Future<void> _handleStart() async {
    hideKeyboard(context);
    await _pingData.removeAllElements(context);

    _targetHost = _target;
    // ignore: use_build_context_synchronously
    context.read<PingBloc>().add(PingStarted(_target));
  }

  void _handleStop() {
    context.read<PingBloc>().add(PingStopped());
  }
}
