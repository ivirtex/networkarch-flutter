// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/theme/theme.dart';

class RoundedList extends StatelessWidget {
  const RoundedList({
    required this.children,
    this.header,
    this.footer,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final String? header;
  final String? footer;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null) SmallDescription(child: header!),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: DataCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: children.length,
              itemBuilder: (context, index) {
                return children[index];
              },
              separatorBuilder: (context, index) {
                return Constants.listDivider;
              },
            ),
          ),
        ),
        if (footer != null) SmallDescription(child: footer!),
      ],
    );
  }
}
