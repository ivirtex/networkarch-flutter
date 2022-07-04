// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/permissions/permissions.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/helpers.dart';

class DebugSection extends StatelessWidget {
  const DebugSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return Column(
          children: [
            const SmallDescription(
              text: 'Debug',
              leftPadding: 8,
            ),
            ToolCard(
              toolName: 'Grant IAP',
              onPressed: () async {
                await Hive.box<bool>('iap').put('ipPremiumGranted', true);
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Clear IAP data',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', false);
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Show permission granted',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  Constants.permissionGrantedSnackbar,
                );
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Show permission denied',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  Constants.permissionDeniedSnackbar,
                );
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Show permission default',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  Constants.permissionDefaultSnackbar,
                );
              },
            ),
            const SizedBox(height: Constants.listSpacing),
          ],
        );
      },
      iosBuilder: (context) {
        return CupertinoListSection.insetGrouped(
          hasLeading: false,
          header: const Text('Debug'),
          children: [
            ToolCard(
              toolName: 'Grant IAP',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', true);
              },
            ),
            ToolCard(
              toolName: 'Clear IAP data',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', false);
              },
            ),
            ToolCard(
              toolName: 'Show permission granted',
              onPressed: () {
                showPlatformMessage(
                  context,
                  type: MessageType.granted,
                );
              },
            ),
            ToolCard(
              toolName: 'Show permission denied',
              onPressed: () {
                showPlatformMessage(
                  context,
                  type: MessageType.denied,
                );
              },
            ),
            ToolCard(
              toolName: 'Show permission default',
              onPressed: () {
                showPlatformMessage(
                  context,
                  type: MessageType.default_,
                );
              },
            ),
            ToolCard(
              toolName: 'Show iOS onboarding',
              onPressed: () {
                showCupertinoModalBottomSheet<void>(
                  context: context,
                  useRootNavigator: true,
                  builder: (context) => const IosOnboarding(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
