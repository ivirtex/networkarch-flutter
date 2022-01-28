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
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        leading: const StatusCard(
          color: Colors.greenAccent,
          text: 'Online',
        ),
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
