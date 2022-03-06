// Flutter imports:
import 'package:flutter/material.dart';

class SmallDescription extends StatelessWidget {
  const SmallDescription({
    required this.child,
    this.leftPadding = 10.0,
    Key? key,
  }) : super(key: key);

  final String child;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 4.0, top: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          child,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
        ),
      ),
    );
  }
}
