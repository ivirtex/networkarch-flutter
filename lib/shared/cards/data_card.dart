// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    Key? key,
    this.child,
    this.margin = const EdgeInsets.symmetric(vertical: 6.0),
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: margin,
      elevation: Platform.isAndroid ? 1.0 : 0.0,
      color: Constants.getPlatformCardColor(context),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
