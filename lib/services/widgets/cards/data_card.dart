// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    this.child,
    this.margin = 10,
    this.onPress,
  });

  final Widget? child;
  final double margin;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPress as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: margin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isDarkModeOn ? Constants.darkBgColor : Constants.lightBgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
