// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.toolName,
    this.toolDesc,
    this.isPremium = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String toolName;
  final String? toolDesc;
  final bool isPremium;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return ActionCard(
          title: toolName,
          desc: toolDesc,
          buttonStyle: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            elevation: 0.0,
            shape: CircleBorder(
              side: isPremium
                  ? BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  : BorderSide.none,
            ),
          ),
          onTap: onPressed,
        );
      },
      iosBuilder: (context) {
        return CupertinoListTile.notched(
          leadingSize: 0.0,
          leadingToTitle: 0.0,
          leading: const SizedBox(),
          title: Text(toolName),
          // TODO: Fix overflow with subtitle
          // subtitle: toolDesc != null
          //     ? Text(
          //         toolDesc!,
          //         overflow: TextOverflow.ellipsis,
          //         maxLines: 2,
          //       )
          //     : null,
          trailing: const CupertinoListTileChevron(),
          onTap: onPressed,
        );
      },
    );
  }
}
