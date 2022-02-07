// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/action_app_bar.dart';
import 'package:network_arch/shared/cupertino_action_app_bar.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class PingView extends StatefulWidget {
  const PingView({Key? key}) : super(key: key);

  @override
  _PingViewState createState() => _PingViewState();
}

class _PingViewState extends State<PingView> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _targetHostController = TextEditingController();
  late final AnimatedListModel<PingData?> _pingData;

  late String _targetHost;

  String get _target => _targetHostController.text;

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
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          BlocBuilder<PingBloc, PingState>(
            builder: (context, state) {
              return state is PingRunInProgress
                  ? CupertinoActionAppBar(
                      context,
                      title: 'Ping',
                      action: ButtonAction.stop,
                      isActive: _target.isNotEmpty,
                      onPressed: _handleStop,
                    )
                  : CupertinoActionAppBar(
                      context,
                      title: 'Ping',
                      action: ButtonAction.start,
                      isActive: _target.isNotEmpty,
                      onPressed: _handleStart,
                    );
            },
          ),
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
          Row(
            children: [
              Expanded(
                child: BlocBuilder<PingBloc, PingState>(
                  builder: (context, state) {
                    if (state is PingRunInProgress) {
                      final repository = context.read<PingRepository>();

                      repository.subscription =
                          state.pingStream.listen((event) {
                        log(event.toString());
                        _pingData.insert(_pingData.length, event);
                      });
                    }

                    return SizedBox(
                      height: 60,
                      child: PlatformWidget(
                        androidBuilder: (context) => TextField(
                          autocorrect: false,
                          controller: _targetHostController,
                          enabled: state is! PingRunInProgress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'IP address (e.g. 1.1.1.1)',
                          ),
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                        iosBuilder: (context) => CupertinoSearchTextField(
                          autocorrect: false,
                          controller: _targetHostController,
                          enabled: state is! PingRunInProgress,
                          placeholder: 'IP address (e.g. 1.1.1.1)',
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 5.0),
              BlocBuilder<PingBloc, PingState>(
                builder: (context, state) {
                  if (state is PingRunComplete && _pingData.isNotEmpty) {
                    return ClearListButton(
                      onPressed: () => _pingData.removeAllElements(context),
                    );
                  }

                  return const ClearListButton();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
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
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    PingData? item,
  ) {
    if (item!.error != null) {
      context.read<PingBloc>().add(PingStopped());

      return FadeTransition(
        opacity: animation.drive(_pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(_pingData.slideTween),
          child: PingCard(
            hasError: true,
            list: _pingData,
            item: item,
            addr: _targetHost,
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
            hasError: false,
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
    await _pingData.removeAllElements(context);

    _targetHost = _target;
    context.read<PingBloc>().add(PingStarted(_target));
  }

  void _handleStop() {
    context.read<PingBloc>().add(PingStopped());
  }
}
