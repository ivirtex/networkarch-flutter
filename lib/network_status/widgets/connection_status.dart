// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/theme/themes.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus(
    this.status, {
    required this.connectionChecker,
    Key? key,
  }) : super(key: key);

  final NetworkStatus status;
  final bool Function() connectionChecker;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20.0;

    final isNetworkConnected = connectionChecker();

    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    switch (status) {
      case NetworkStatus.success:
        return Row(
          children: [
            Text(
              isNetworkConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                color: isNetworkConnected
                    ? Themes.getPlatformSuccessColor(context)
                    : Themes.getPlatformErrorColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(width: 5.0),
            Icon(
              isIOS
                  ? isNetworkConnected
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.xmark_circle_fill
                  : isNetworkConnected
                      ? Icons.check_circle
                      : Icons.cancel,
              size: iconSize,
              color: isNetworkConnected
                  ? Themes.getPlatformSuccessColor(context)
                  : Themes.getPlatformErrorColor(context),
            ),
          ],
        );
      case NetworkStatus.permissionIssue:
        return Row(
          children: [
            Text(
              'Permission issue',
              style: TextStyle(
                color: isNetworkConnected
                    ? Themes.getPlatformSuccessColor(context)
                    : Themes.getPlatformErrorColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(width: 5.0),
            Icon(
              isIOS ? CupertinoIcons.xmark_circle_fill : Icons.cancel,
              size: iconSize,
              color: isNetworkConnected
                  ? Themes.getPlatformSuccessColor(context)
                  : Themes.getPlatformErrorColor(context),
            ),
          ],
        );
      case NetworkStatus.failure:
        return Row(
          children: [
            Text(
              'Error',
              style: TextStyle(
                color: isNetworkConnected
                    ? Themes.getPlatformSuccessColor(context)
                    : Themes.getPlatformErrorColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(width: 5.0),
            Icon(
              isIOS ? CupertinoIcons.xmark_circle_fill : Icons.cancel,
              size: iconSize,
              color: isNetworkConnected
                  ? Themes.getPlatformSuccessColor(context)
                  : Themes.getPlatformErrorColor(context),
            ),
          ],
        );
      default:
        return Row(
          children: const [
            Text(
              'Checking connection...',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(width: 5.0),
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 3.0,
              ),
            ),
          ],
        );
    }
  }
}
