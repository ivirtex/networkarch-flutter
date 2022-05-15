// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.title,
    required this.desc,
    this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final String desc;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      margin: EdgeInsetsDirectional.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FaIcon(icon),
          ),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  desc,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption?.color,
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
                shape: const CircleBorder(),
              ),
              onPressed: onTap,
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
