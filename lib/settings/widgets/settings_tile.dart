// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
