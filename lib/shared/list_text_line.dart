// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/list_circular_progress_indicator.dart';

class ListTextLine extends StatelessWidget {
  const ListTextLine({
    required this.widgetL,
    this.widgetR,
    this.onRefreshTap,
    Key? key,
  }) : super(key: key);

  final Widget widgetL;
  final Widget? widgetR;
  final VoidCallback? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 5.0,
      spacing: 5.0,
      children: [
        widgetL,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRefreshTap != null)
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(right: 4),
                splashRadius: 12.0,
                iconSize: 16.0,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.blue,
                ),
                onPressed: onRefreshTap,
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                print('ListTextLine: ${constraints.maxWidth}');

                return widgetR ?? const ListCircularProgressIndicator();
              },
            ),
          ],
        ),
      ],
    );
  }
}
