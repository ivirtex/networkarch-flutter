// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/utils.dart';

class PingView extends StatefulWidget {
  const PingView({super.key});

  @override
  _PingViewState createState() => _PingViewState();
}

class _PingViewState extends State<PingView> {
  final _appBarKey = GlobalKey<ActionAppBarState>();
  final _listKey = GlobalKey<AnimatedListState>();
  final _targetHostController = TextEditingController();
  final _scrollController = ScrollController();
  late final AnimatedListModel<PingData> _pingData;

  String get _target => _targetHostController.text;

  bool _shouldStartButtonBeActive = false;
  bool _isClearListButtonLocked = false;
  bool _shouldAutoScroll = true;
  bool _isFabVisible = false;

  @override
  void initState() {
    super.initState();

    _pingData = AnimatedListModel<PingData>(
      listKey: _listKey,
      removedItemBuilder: _buildItem,
    );

    if (kDebugMode) {
      _targetHostController.text = '1.1.1.1';
    }

    _scrollController.addListener(() {
      _shouldAutoScroll = _scrollController.offset ==
          _scrollController.position.maxScrollExtent;

      final shouldFabBeVisible = _scrollController.offset > 0;

      if (shouldFabBeVisible != _isFabVisible) {
        setState(() {
          _isFabVisible = shouldFabBeVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _targetHostController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routedAddr =
        // ignore: cast_nullable_to_non_nullable
        ModalRoute.of(context)!.settings.arguments as String;
    if (routedAddr.isNotEmpty) _targetHostController.text = routedAddr;

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
      body: _buildBody(context),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward_rounded),
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
            )
          : null,
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Ping'),
      navBarTrailingWidget: BlocBuilder<PingBloc, PingState>(
        builder: (context, state) {
          return state is PingRunNewData
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _handleStop,
                  child: Text(
                    'Stop',
                    style: TextStyle(
                      color: CupertinoColors.systemRed.resolveFrom(context),
                    ),
                  ),
                )
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _shouldStartButtonBeActive ? _handleStart : null,
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: _shouldStartButtonBeActive
                          ? CupertinoColors.systemGreen.resolveFrom(context)
                          : CupertinoColors.placeholderText
                              .resolveFrom(context),
                    ),
                  ),
                );
        },
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ContentListView(
      scrollController: _scrollController,
      usePaddingOniOS: true,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocConsumer<PingBloc, PingState>(
                listener: (context, state) => _handleNewData(state),
                builder: (context, state) {
                  return Expanded(
                    child: DomainTextField(
                      controller: _targetHostController,
                      label: 'IP address (e.g. 1.1.1.1)',
                      enabled: state is PingInitial || state is PingRunComplete,
                      onChanged: (_) {
                        setState(() {
                          _shouldStartButtonBeActive = _target.isNotEmpty;
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              BlocBuilder<PingBloc, PingState>(
                builder: (context, state) {
                  if (_pingData.isNotEmpty && !_isClearListButtonLocked) {
                    return ClearListButton(
                      onPressed: () async {
                        setState(() {
                          _isClearListButtonLocked = true;
                        });

                        await _pingData.removeAllElements(context);

                        setState(() {
                          _isClearListButtonLocked = false;
                        });
                      },
                    );
                  }

                  return const ClearListButton();
                },
              ),
            ],
          ),
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
    PingData item,
  ) {
    return FadeTransition(
      opacity: animation.drive(_pingData.fadeTween),
      child: SlideTransition(
        position: animation.drive(_pingData.slideTween),
        child: PingCard(
          list: _pingData,
          item: item,
          addr: context.read<PingBloc>().target!.isEmpty
              ? 'N/A'
              : context.read<PingBloc>().target!,
          hasError: item.error != null,
        ),
      ),
    );
  }

  Future<void> _handleStart() async {
    hideKeyboard(context);

    setState(() {
      _isClearListButtonLocked = true;
    });

    await _pingData.removeAllElements(context);

    if (!mounted) return;
    context.read<PingBloc>().add(PingStarted(_target));

    _targetHostController.text = '';
    _shouldStartButtonBeActive = false;
  }

  void _handleStop() {
    context.read<PingBloc>().add(PingStopped());

    setState(() {
      _isClearListButtonLocked = false;
    });
  }

  void _handleNewData(PingState state) {
    if (state is PingRunNewData) {
      _pingData.insert(_pingData.length, state.pingData);

      if (_shouldAutoScroll) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
          );
        });
      }

      if (state.pingData.error != null &&
          state.pingData.error?.error != ErrorType.requestTimedOut) {
        _appBarKey.currentState?.toggleAnimation();

        _handleStop();
      }
    }
  }
}
