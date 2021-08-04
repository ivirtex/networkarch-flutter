// Flutter imports:
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    this.cardChild,
    this.onPress,
  });

  final Widget? cardChild;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPress as void Function()?,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isDarkModeOn ? Colors.grey[800] : Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardChild,
        ),
      ),
    );
  }
}
