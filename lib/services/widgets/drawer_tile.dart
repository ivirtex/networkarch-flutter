// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.icon,
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final FaIcon icon;
  final Widget child;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          child,
        ],
      ),
      onTap: onTap as void Function()?,
    );
  }
}
