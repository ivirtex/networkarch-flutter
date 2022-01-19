// Flutter imports:

// Flutter imports:

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/models/ping_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class PingView extends StatefulWidget {
  const PingView({Key? key}) : super(key: key);

  @override
  _PingViewState createState() => _PingViewState();
}

class _PingViewState extends State<PingView>
    with SingleTickerProviderStateMixin {
  late final PingModel provider;

  final targetHostController = TextEditingController();
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    context.read<PingModel>().pingData = AnimatedListModel<PingData>(
      listKey: _listKey,
      itemBuilder: _buildItem,
    );
    provider = context.read<PingModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String routedAddr =
        // ignore: cast_nullable_to_non_nullable
        ModalRoute.of(context)!.settings.arguments as String;
    targetHostController.text = routedAddr;
  }

  @override
  void dispose() {
    super.dispose();

    targetHostController.dispose();
    provider.onDispose();
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
      appBar: context.read<PingModel>().isPingingStarted
          ? Builders.switchableAppBar(
              context: context,
              title: 'Ping',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: context.read<PingModel>().handleStopButtonPressed,
            )
          : Builders.switchableAppBar(
              context: context,
              title: 'Ping',
              action: ButtonActions.start,
              isActive: targetHostController.text.isNotEmpty,
              onPressed: () =>
                  context.read<PingModel>().handleStartButtonPressed(
                        context,
                        targetHostController,
                      ),
            ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Ping'),
              onPressed: () =>
                  context.read<PingModel>().handleStartButtonPressed(
                        context,
                        targetHostController,
                      ),
            ),
            stretch: true,
            border: null,
            largeTitle: const Text(
              'Ping',
            ),
          )
        ],
        body: _buildBody(context),
      ),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PlatformWidget(
                  androidBuilder: (context) => TextField(
                    autocorrect: false,
                    controller: targetHostController,
                    enabled: !context.read<PingModel>().isPingingStarted,
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
                    controller: targetHostController,
                    enabled: !context.read<PingModel>().isPingingStarted,
                    placeholder: 'IP address (e.g. 1.1.1.1)',
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: context.watch<PingModel>().isPingingStarted ||
                        context.read<PingModel>().pingData.isEmpty
                    ? null
                    : () => context
                        .read<PingModel>()
                        .pingData
                        .removeAllElements(context),
                child: const Text('Clear list'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            initialItemCount: context.read<PingModel>().pingData.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(
                context,
                animation,
                context.read<PingModel>().pingData[index],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    PingData? item,
  ) {
    final pingModel = context.read<PingModel>();

    // print('building for $item element');

    if (item!.error != null) {
      return FadeTransition(
        opacity: animation.drive(pingModel.pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(pingModel.pingData.slideTween),
          child: DataCard(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 8.0, right: 16.0),
              leading: const StatusCard(
                color: Colors.red,
                text: 'Error',
              ),
              title: Text(
                pingModel.getHost ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seq. pos.: ${pingModel.pingData.indexOf(item) + 1}'),
                  const Text('TTL: N/A'),
                ],
              ),
              trailing: SizedBox(
                width: 110,
                child: Text(
                  pingModel.getErrorDesc(item.error!),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (item.response != null) {
      return FadeTransition(
        opacity: animation.drive(pingModel.pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(pingModel.pingData.slideTween),
          child: DataCard(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 8.0, right: 16.0),
              leading: const StatusCard(
                color: Colors.green,
                text: 'Online',
              ),
              title: Text(
                item.response!.ip!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seq. pos.: ${item.response!.seq.toString()} '),
                  Text('TTL: ${item.response!.ttl.toString()}')
                ],
              ),
              trailing: Text(
                '${item.response!.time!.inMilliseconds.toString()} ms',
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
