// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';

class RoundedList extends StatelessWidget {
  const RoundedList({
    required this.children,
    this.padding = const EdgeInsets.all(10.0),
    this.header,
    this.footer,
    this.onHeaderTapped,
    this.onFooterTapped,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  /// Preferably a List of ListTextLine widgets.
  final List<Widget> children;
  final EdgeInsets padding;
  final String? header;
  final String? footer;
  final VoidCallback? onHeaderTapped;
  final VoidCallback? onFooterTapped;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null)
          GestureDetector(
            child: SmallDescription(child: header!),
          ),
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
                return Padding(
                  padding: padding,
                  child: children[index],
                );
              },
              separatorBuilder: (context, index) {
                return Constants.listDivider;
              },
            ),
          ),
        ),
        if (footer != null)
          GestureDetector(
            child: SmallDescription(child: footer!),
          ),
      ],
    );
  }
}
