// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.toolName,
    required this.toolDesc,
    this.isPremium = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String toolName;
  final String toolDesc;
  final bool isPremium;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      margin: EdgeInsetsDirectional.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toolName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  toolDesc,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                elevation: 0.0,
                shape: CircleBorder(
                  side: isPremium
                      ? BorderSide(
                          width: 2.0,
                          color: Colors.yellow.shade600,
                        )
                      : BorderSide.none,
                ),
              ),
              onPressed: onPressed,
              child: FaIcon(
                FontAwesomeIcons.circleArrowRight,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
