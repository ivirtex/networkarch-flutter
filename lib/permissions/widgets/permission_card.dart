// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/theme/themes.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iOSicon,
    required this.status,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String description;
  final FaIcon icon;
  final Icon iOSicon;
  final PermissionStatus status;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataCard(
          child: Row(
            children: [
              Flexible(
                child: Center(child: icon),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      description,
                      style: isDarkModeOn
                          ? Constants.descStyleDark
                          : Constants.descStyleLight,
                    ),
                  ],
                ),
              ),
              if (status.isGranted)
                const Flexible(
                  flex: 3,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.circleCheck,
                      color: Colors.green,
                    ),
                  ),
                )
              else if (status.isPermanentlyDenied)
                const Flexible(
                  flex: 3,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.red,
                    ),
                  ),
                )
              else
                Flexible(
                  flex: 3,
                  child: Center(
                    child: TextButton(
                      onPressed: onPressed,
                      child: const Text('Request'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Themes.iOSOnboardingBgColor.resolveFrom(context),
      header: Text(title),
      children: [
        CupertinoListTile(
          backgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGrey6.color,
            darkColor: CupertinoColors.systemGrey5.darkColor,
          ).resolveFrom(context),
          leading: iOSicon,
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 150,
              maxHeight: 500,
            ),
            child: Text(
              description,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: status.isGranted
              ? Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Themes.getPlatformSuccessColor(context),
                )
              : status.isPermanentlyDenied
                  ? Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: Themes.getPlatformErrorColor(context),
                    )
                  : CupertinoButton(
                      onPressed: onPressed,
                      child: const Text('Request'),
                    ),
          padding: Constants.cupertinoListTileWithIconPadding,
        ),
      ],
    );
  }
}
