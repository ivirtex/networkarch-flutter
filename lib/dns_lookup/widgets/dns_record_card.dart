// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/themes.dart';

class DnsRecordCard extends StatelessWidget {
  const DnsRecordCard(
    this.record, {
    Key? key,
  }) : super(key: key);

  final DnsRecord record;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final iOStextColor = Themes.iOStextColor.resolveFrom(context);

    return DataCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${rrCodeToName(record.type).name} Record',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isIOS ? iOStextColor : null,
                ),
              ),
              const Spacer(),
              Text(
                'TTL: ${record.ttl.toString()}',
                style: TextStyle(
                  color: isIOS ? iOStextColor : null,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              record.name,
              style: Constants.descStyleDark,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              record.data,
              style: TextStyle(
                color: isIOS ? iOStextColor : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
