// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.title,
    this.desc,
    this.icon,
    this.buttonStyle,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? desc;
  final IconData? icon;
  final ButtonStyle? buttonStyle;
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
                  padding: const EdgeInsets.only(right: 14.0, left: 7.0),
                  child: FaIcon(icon),
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
                        fontSize: 20.0,
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
              ElevatedButton(
                style: buttonStyle ??
                    ElevatedButton.styleFrom(
                      primary: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.15),
                      elevation: 0.0,
                      shape: const CircleBorder(),
                    ),
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
          subtitle: desc != null ? Text(desc!) : null,
          leading: icon != null ? Icon(icon) : null,
          trailing: const CupertinoListTileChevron(),
          onTap: onTap,
        );
      },
    );
  }
}
