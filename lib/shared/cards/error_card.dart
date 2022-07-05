// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/themes.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return DataCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            isIOS ? CupertinoIcons.xmark_circle : FontAwesomeIcons.circleXmark,
            color: Themes.getPlatformErrorColor(context),
            size: 25,
          ),
          const SizedBox(width: 5),
          Text(
            message ?? Constants.defaultError,
            style: TextStyle(
              fontSize: 15,
              color: Themes.getPlatformErrorColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
