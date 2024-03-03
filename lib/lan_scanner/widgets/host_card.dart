// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:lan_scanner/lan_scanner.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class HostCard extends StatelessWidget {
  const HostCard({
    required this.item,
    super.key,
  });

  final Host item;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: const StatusCard(
          color: Colors.green,
          text: 'Online',
        ),
        // TODO(ivirtex): Add resolving hostname
        // title: FutureBuilder(
        //   future: item.reverse(),
        //   builder:
        //       (BuildContext context, AsyncSnapshot<InternetAddress> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Text('Loading...');
        //     }
        //     if (snapshot.hasError) {
        //       print(snapshot.error);

        //       if (snapshot.error is SocketException) {
        //         return const Text('N/A');
        //       }

        //       throw snapshot.error!;
        //     }

        //     return Text(snapshot.data?.host ?? 'N/A');
        //   },
        // ),
        title: Text(item.internetAddress.address),
        subtitle: Text('${item.pingTime!.inMilliseconds} ms'),
        trailing: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/tools/ping',
              arguments: item.internetAddress.address,
            );
          },
          child: const Text('Ping'),
        ),
      ),
    );
  }
}
