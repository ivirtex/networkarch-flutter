// Flutter imports:
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    this.color,
    this.cardChild,
    this.onPress,
  });

  final Color? color;
  final Widget? cardChild;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress as void Function()?,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardChild,
        ),
      ),
    );
  }
}
