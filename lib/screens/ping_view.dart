// Flutter imports:

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/ping_model.dart';
import 'package:network_arch/services/utils/keyboard_hider.dart';
import 'package:network_arch/services/widgets/builders.dart';
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

  final Animatable<Offset> _slideTween = Tween<Offset>(
    begin: const Offset(0, 1),
    end: const Offset(0, 0),
  ).chain(CurveTween(curve: Curves.easeInOut));

  final Animatable<double> _fadeTween = Tween<double>(begin: 0, end: 1);

  @override
  void initState() {
    // TODO: implement initStated
    super.initState();

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

  Widget _buildItem(
      BuildContext context, Animation<double> animation, PingData? item) {
    final pingModel = context.read<PingModel>();

    print('building for $item element');

    if (item!.error != null) {
      return FadeTransition(
        opacity: animation.drive(_fadeTween),
        child: SlideTransition(
          position: animation.drive(_slideTween),
          child: Card(
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
        opacity: animation.drive(_fadeTween),
        child: SlideTransition(
          position: animation.drive(_slideTween),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
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

  void _handleStartButtonPressed(BuildContext context) {
    final PingModel pingModel = context.read<PingModel>();

    setState(() {
      pingModel.clearData();
      pingModel.setHost(
        targetHostController.text.isEmpty ? null : targetHostController.text,
      );
      pingModel.isPingingStarted = true;
    });

    final stream = pingModel.getStream();

    stream.listen((PingData event) {
      pingModel.pingData.add(event);
      _listKey.currentState!.insertItem(pingModel.pingData.length - 1);
    });

    targetHostController.clear();
    hideKeyboard(context);
  }

  Future<void> _removeLastElement(BuildContext context) async {
    final pingData = context.read<PingModel>().pingData;
    final int index = pingData.length - 1;

    _listKey.currentState!.removeItem(
        index,
        (context, animation) => _buildItem(
              context,
              animation,
              pingData.last,
            ));

    // Default insert/remove animation duration is 300 ms,
    // so we need to wait for the animation to complete
    // before we can remove object from the list.
    await Future.delayed(const Duration(milliseconds: 350));

    setState(() {
      context.read<PingModel>().pingData.removeAt(index);
    });
  }

  Future<void> _removeAllElements(BuildContext context) async {
    final dataList = context.read<PingModel>().pingData;

    for (int i = dataList.length - 1; i >= 0; --i) {
      final PingData? removedItem = dataList.removeAt(i);

      _listKey.currentState!.removeItem(i,
          (context, animation) => _buildItem(context, animation, removedItem));

      await Future.delayed(const Duration(milliseconds: 100));
    }

    dataList.clear();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: targetHostController,
                      autocorrect: false,
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
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: context.watch<PingModel>().isPingingStarted
                        ? null
                        : () => _removeAllElements(context),
                    child: const Text('Clear list'),
                  ),
                ],
              ),
            ),
            AnimatedList(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              key: _listKey,
              initialItemCount: context.read<PingModel>().pingData.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(
                  context,
                  animation,
                  context.read<PingModel>().pingData.elementAt(index),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
