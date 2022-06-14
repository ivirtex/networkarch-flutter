// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';

class RoundedList extends StatelessWidget {
  const RoundedList({
    required this.children,
    this.padding = const EdgeInsets.all(10.0),
    this.header,
    this.footer,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  /// Preferably a List of ListTextLine widgets.
  final List<Widget> children;
  final EdgeInsets padding;
  final String? header;
  final String? footer;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return Column(
          children: [
            if (header != null) SmallDescription(text: header!),
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
                    return Divider(
                      indent: Constants.listDividerIndent,
                      height: 1.0 / MediaQuery.of(context).devicePixelRatio,
                    );
                  },
                ),
              ),
            ),
            if (footer != null) SmallDescription(text: footer!),
          ],
        );
      },
      iosBuilder: (context) {
        return CupertinoListSection.insetGrouped(
          hasLeading: false,
          header: header != null ? Text(header!) : null,
          footer: footer != null ? Text(footer!) : null,
          children: children,
        );
      },
    );
  }
}
