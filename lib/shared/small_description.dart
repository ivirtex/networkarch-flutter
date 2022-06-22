// Flutter imports:
import 'package:flutter/material.dart';

class SmallDescription extends StatelessWidget {
  const SmallDescription({
    required this.text,
    this.leftPadding = 10.0,
    this.topPadding = 4.0,
    super.key,
  });

  final String text;
  final double leftPadding;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        bottom: 4,
        top: topPadding,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
