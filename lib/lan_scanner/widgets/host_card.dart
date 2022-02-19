// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class HostCard extends StatelessWidget {
  const HostCard({
    required this.item,
    Key? key,
  }) : super(key: key);

  final InternetAddress item;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        leading: const StatusCard(
          color: Colors.green,
          text: 'Online',
        ),
        // TODO: Add resolving hostname
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
        title: Text(item.address),
        trailing: TextButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed(
              '/tools/ping',
              arguments: item.address,
            );
          },
          child: const Text('Ping'),
        ),
      ),
    );
  }
}
