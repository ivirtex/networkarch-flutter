// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.title,
    this.desc,
    this.icon,
    this.shape,
    this.onTap,
    super.key,
  });

  final String title;
  final String? desc;
  final FaIcon? icon;
  final OutlinedBorder? shape;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return DataCard(
          margin: EdgeInsetsDirectional.zero,
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 14, left: 7),
                  child: icon,
                ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    if (desc != null)
                      Text(
                        desc!,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption?.color,
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              AdaptiveButton(
                buttonType: ButtonType.filledTonal,
                shape: shape ?? const CircleBorder(),
                onPressed: onTap,
                child: FaIcon(
                  FontAwesomeIcons.circleArrowRight,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        );
      },
      iosBuilder: (context) {
        return CupertinoListTile.notched(
          title: Text(title),
          subtitle: desc != null
              ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 200,
                  ),
                  child: Text(
                    desc!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          leading: icon,
          trailing: const CupertinoListTileChevron(),
          padding: Constants.cupertinoListTileWithIconPadding,
          onTap: onTap,
        );
      },
    );
  }
}
