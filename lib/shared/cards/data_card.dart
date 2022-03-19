// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    Key? key,
    this.child,
    this.margin = const EdgeInsets.only(bottom: 10.0),
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: margin,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
