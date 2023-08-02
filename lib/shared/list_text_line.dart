// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/list_circular_progress_indicator.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class ListTextLine extends StatelessWidget {
  const ListTextLine({
    required this.widgetL,
    this.widgetR,
    this.subtitle,
    this.onRefreshTap,
    super.key,
  });

  final Widget widgetL;
  final Widget? widgetR;
  final Widget? subtitle;
  final VoidCallback? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    // TODO(ivirtex): improve alignment of widgets on wrap
    return PlatformWidget(
      androidBuilder: (_) => Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 5,
        spacing: 5,
        children: [
          widgetL,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onRefreshTap != null)
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(right: 4),
                  splashRadius: 12,
                  iconSize: 16,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                  ),
                  onPressed: onRefreshTap,
                ),
              widgetR ?? const ListCircularProgressIndicator(),
            ],
          ),
        ],
      ),
      iosBuilder: (_) => CupertinoListTile.notched(
        title: widgetL,
        trailing: Flexible(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: widgetR,
          ),
        ),
        subtitle: subtitle,
        onTap: onRefreshTap,
      ),
    );
  }
}
