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
          shape: CircleBorder(
            side: isPremium
                ? BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.tertiary,
                  )
                : BorderSide.none,
          ),
          onTap: onPressed,
        );
      },
      iosBuilder: (context) {
        return CupertinoListTile.notched(
          title: Text(toolName),
          // TODO: Fix overflow with subtitle
          // subtitle: toolDesc != null
          //     ? Text(
          //         toolDesc!,
          //         overflow: TextOverflow.ellipsis,
          //       )
          //     : null,
          trailing: const CupertinoListTileChevron(),
          onTap: onPressed,
        );
      },
    );
  }
}
