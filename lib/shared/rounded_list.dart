// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class RoundedList extends StatelessWidget {
  const RoundedList({
    required this.children,
    this.padding,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsets? padding;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    for (var i = 1; i < children.length; i++) {
      if ((i + 1).isEven) {
        children.insert(i, Constants.listDivider);
      }
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: Platform.isAndroid ? 1.0 : 0.0,
        color: bgColor ?? Constants.getPlatformCardColor(context),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: children,
        ),
      ),
    );
  }
}
