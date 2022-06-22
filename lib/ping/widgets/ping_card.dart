// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/ping/repository/repository.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/themes.dart';

class PingCard extends StatelessWidget {
  const PingCard({
    required this.list,
    required this.item,
    required this.addr,
    this.hasError = false,
    Key? key,
  }) : super(key: key);

  final AnimatedListModel<PingData?> list;
  final PingData item;
  final String addr;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return DataCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 8.0, right: 16.0),
        leading: hasError
            ? StatusCard(
                color: isIos ? CupertinoColors.systemRed : Colors.red,
                text: 'Offline',
              )
            : StatusCard(
                color: isIos ? CupertinoColors.systemGreen : Colors.green,
                text: 'Online',
              ),
        title: Text(
          addr.isEmpty ? 'N/A' : addr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIos ? Themes.iOStextColor.resolveFrom(context) : null,
          ),
        ),
        subtitle: hasError
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seq. pos.: ${list.indexOf(item) + 1}',
                    style: TextStyle(
                      color: isIos
                          ? Themes.iOStextColor.resolveFrom(context)
                          : null,
                    ),
                  ),
                  Text(
                    'TTL: N/A',
                    style: TextStyle(
                      color: isIos
                          ? Themes.iOStextColor.resolveFrom(context)
                          : null,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seq. pos.: ${item.response!.seq.toString()} ',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: isIos
                              ? Themes.iOStextColor.resolveFrom(context)
                              : null,
                        ),
                  ),
                  Text(
                    'TTL: ${item.response!.ttl.toString()}',
                    style: TextStyle(
                      color: isIos
                          ? Themes.iOStextColor.resolveFrom(context)
                          : null,
                    ),
                  ),
                ],
              ),
        trailing: hasError
            ? Text(
                context.read<PingRepository>().getErrorDesc(
                      item.error!,
                    ),
                style: TextStyle(
                  color:
                      isIos ? Themes.iOStextColor.resolveFrom(context) : null,
                ),
              )
            : Text(
                '${item.response!.time!.inMilliseconds.toString()} ms',
                style: TextStyle(
                  color: item.response!.time!.inMilliseconds < 75
                      ? isIos
                          ? CupertinoColors.systemGreen
                          : Colors.green
                      : item.response!.time!.inMilliseconds < 150
                          ? isIos
                              ? CupertinoColors.systemYellow
                              : Colors.yellow[700]
                          : isIos
                              ? CupertinoColors.systemRed
                              : Colors.red[700],
                ),
              ),
      ),
    );
  }
}
