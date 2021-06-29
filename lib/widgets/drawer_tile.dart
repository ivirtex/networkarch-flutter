import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.icon,
    required this.child,
    required this.onTap,
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
          SizedBox(width: 10),
          child,
        ],
      ),
      onTap: onTap as void Function()?,
    );
  }
}
