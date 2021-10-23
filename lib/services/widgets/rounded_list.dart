import 'dart:io';

import 'package:flutter/material.dart';
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
      if ((i + 1) % 2 == 0) {
        children.insert(i, Constants.listDivider);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: Platform.isAndroid ? 1.0 : 0.0,
        color: bgColor ?? Constants.getPlatformBgColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
