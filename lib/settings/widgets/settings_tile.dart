// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Text title;
  final IconData icon;
  final Text? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Theme.of(context).iconTheme.color,
      // Used to center the icon in the tile.
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon),
        ],
      ),
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
