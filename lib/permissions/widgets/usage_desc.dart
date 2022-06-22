// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class UsageDesc extends StatelessWidget {
  const UsageDesc({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Text(
      Constants.usageDesc,
      style: isDarkModeOn ? Constants.descStyleDark : Constants.descStyleLight,
    );
  }
}
