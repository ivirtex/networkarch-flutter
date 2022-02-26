// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class RoundedList extends StatelessWidget {
  const RoundedList({
    required this.children,
    this.header,
    this.footer,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    for (var i = 1; i < children.length; i++) {
      if ((i + 1).isEven) {
        children.insert(i, Constants.listDivider);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: header,
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: Platform.isAndroid ? 1.0 : 0.0,
          color: bgColor ?? Constants.getPlatformCardColor(context),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: children,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 3.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: footer,
          ),
        ),
      ],
    );
  }
}
