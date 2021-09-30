// Flutter imports:

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/list_model.dart';
import 'package:network_arch/models/ping_model.dart';
import 'package:network_arch/services/utils/keyboard_hider.dart';
import 'package:network_arch/services/widgets/builders.dart';
import 'package:network_arch/services/widgets/platform_widget.dart';
import 'package:network_arch/services/widgets/shared_widgets.dart';

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
    // TODO: implement initStated
    super.initState();

    context.read<PingModel>().pingData = AnimatedListModel<PingData>(
      listKey: _listKey,
      itemBuilder: _buildItem,
    );
    provider = context.read<PingModel>();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
    provider.stopStream();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildItem(
      BuildContext context, Animation<double> animation, PingData? item) {
    final pingModel = context.read<PingModel>();

    print('building for $item element');

    if (item!.error != null) {
      return FadeTransition(
        opacity: animation.drive(pingModel.pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(pingModel.pingData.slideTween),
          child: Card(
            color: Constants.lightBgColor,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              leading: const StatusCard(
                color: CupertinoColors.systemRed,
                text: 'Error',
              ),
              title: Text(pingModel.getHost ?? 'N/A'),
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
          child: Card(
            color: Constants.lightBgColor,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
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
      return Container();
    }
  }

  void _handleStopButtonPressed(BuildContext context) {
    final PingModel pingModel = context.read<PingModel>();

    setState(() {
      pingModel.stopStream();
      pingModel.isPingingStarted = false;
    });
  }

  Future<void> _handleStartButtonPressed(BuildContext context) async {
    final PingModel pingModel = context.read<PingModel>();

    await pingModel.pingData.removeAllElements(context);

    setState(() {
      pingModel.setHost(
        targetHostController.text.isEmpty ? null : targetHostController.text,
      );
      pingModel.isPingingStarted = true;
    });

    final stream = pingModel.getStream();

    stream.listen((PingData event) {
      // final int length =
      //     pingModel.pingData.length == 0 ? 0 : pingModel.pingData.length - 1;

      pingModel.pingData.insert(pingModel.pingData.length, event);
    });

    targetHostController.clear();
    hideKeyboard(context);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: context.read<PingModel>().isPingingStarted
          ? Builders.switchableAppBar(
              context: context,
              title: 'Ping',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: () => _handleStopButtonPressed(context),
            )
          : Builders.switchableAppBar(
              context: context,
              title: 'Ping',
              action: ButtonActions.start,
              isActive: targetHostController.text.isNotEmpty,
              onPressed: () => _handleStartButtonPressed(context),
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
              padding: const EdgeInsets.all(0),
              child: const Text('Ping'),
              onPressed: () => _handleStartButtonPressed(context),
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
                          borderRadius: BorderRadius.circular(10.0)),
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
                onPressed: context.watch<PingModel>().isPingingStarted
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
}
