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

class PingCard extends StatelessWidget {
  const PingCard({
    required this.list,
    required this.item,
    required this.addr,
    this.hasError = false,
    super.key,
  });

  final AnimatedListModel<PingData?> list;
  final PingData item;
  final String addr;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return DataCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 8, right: 16),
            leading: hasError
                ? const StatusCard(
                    color: Colors.red,
                    text: 'Offline',
                  )
                : const StatusCard(
                    color: Colors.green,
                    text: 'Online',
                  ),
            title: Text(
              addr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: hasError
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seq. pos.: ${list.indexOf(item) + 1}',
                      ),
                      const Text(
                        'TTL: N/A',
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seq. pos.: ${item.response!.seq} ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'TTL: ${item.response!.ttl}',
                      ),
                    ],
                  ),
            trailing: hasError
                ? Text(
                    context.read<PingRepository>().getErrorDesc(
                          item.error!,
                        ),
                  )
                : Text(
                    '${item.response!.time!.inMilliseconds} ms',
                    style: TextStyle(
                      color: item.response!.time!.inMilliseconds < 75
                          ? Colors.green
                          : item.response!.time!.inMilliseconds < 150
                              ? Colors.yellow
                              : Colors.red,
                    ),
                  ),
          ),
        );
      },
      iosBuilder: (context) {
        return CupertinoListTile.notched(
          title: Text(
            addr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: hasError
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seq. pos.: ${list.indexOf(item) + 1}',
                    ),
                    const Text(
                      'TTL: N/A',
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seq. pos.: ${item.response!.seq} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'TTL: ${item.response!.ttl}',
                    ),
                  ],
                ),
          trailing: hasError
              ? Text(
                  context.read<PingRepository>().getErrorDesc(
                        item.error!,
                      ),
                )
              : Text(
                  '${item.response!.time!.inMilliseconds} ms',
                  style: TextStyle(
                    color: item.response!.time!.inMilliseconds < 75
                        ? CupertinoColors.systemGreen
                        : item.response!.time!.inMilliseconds < 150
                            ? CupertinoColors.systemYellow
                            : CupertinoColors.systemRed,
                  ),
                ),
        );
      },
    );
  }
}
