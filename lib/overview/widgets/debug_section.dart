// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/shared/shared.dart';

class DebugSection extends StatelessWidget {
  const DebugSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SmallDescription(
          text: 'Debug',
          leftPadding: 8.0,
        ),
        ToolCard(
          toolName: 'Clear IAP data',
          toolDesc: '',
          onPressed: () async {
            await Hive.box('iap').put('isPremiumGranted', false);
          },
        ),
        const SizedBox(height: Constants.listSpacing),
        ToolCard(
          toolName: 'Show permission granted',
          toolDesc: '',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              Constants.permissionGrantedSnackbar,
            );
          },
        ),
        const SizedBox(height: Constants.listSpacing),
        ToolCard(
          toolName: 'Show permission denied',
          toolDesc: '',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              Constants.permissionDeniedSnackbar,
            );
          },
        ),
        const SizedBox(height: Constants.listSpacing),
        ToolCard(
          toolName: 'Show permission default',
          toolDesc: '',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              Constants.permissionDefaultSnackbar,
            );
          },
        ),
        const SizedBox(height: Constants.listSpacing),
      ],
    );
  }
}
