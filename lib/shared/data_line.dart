// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/list_circular_progress_indicator.dart';

class DataLine extends StatelessWidget {
  const DataLine({
    required this.textL,
    this.textR,
    this.padding,
    this.onRefreshTap,
    Key? key,
  }) : super(key: key);

  final Text textL;
  final Text? textR;
  final EdgeInsets? padding;
  final VoidCallback? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (textR != null) {
            if (constraints.maxWidth < 200 || textR!.data!.length > 40) {
              return Column(
                children: [
                  Row(
                    children: [
                      textL,
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      if (onRefreshTap != null)
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(right: 4),
                          splashRadius: 12.0,
                          iconSize: 16.0,
                          icon: const Icon(Icons.refresh, color: Colors.blue),
                          onPressed: onRefreshTap,
                        ),
                      textR!,
                    ],
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  textL,
                  const Spacer(),
                  if (onRefreshTap != null)
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.only(right: 4),
                      splashRadius: 12.0,
                      iconSize: 16.0,
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      onPressed: onRefreshTap,
                    ),
                  textR!,
                ],
              );
            }
          } else {
            return Row(
              children: [
                textL,
                const Spacer(),
                const ListCircularProgressIndicator()
              ],
            );
          }
        },
      ),
    );
  }
}
