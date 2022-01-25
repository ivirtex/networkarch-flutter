import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_arch/utils/enums.dart';

class ActionAppBar extends StatelessWidget with PreferredSizeWidget {
  const ActionAppBar(
    this.context, {
    required this.title,
    required this.action,
    required this.isActive,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final ButtonActions action;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      iconTheme: Theme.of(context).iconTheme,
      actions: [
        if (action == ButtonActions.start)
          IconButton(
            splashRadius: 25.0,
            icon: FaIcon(
              FontAwesomeIcons.play,
              color: isActive ? Colors.green : Colors.grey,
            ),
            onPressed: isActive ? onPressed : null,
          )
        else
          IconButton(
            splashRadius: 25.0,
            icon: FaIcon(
              FontAwesomeIcons.stopCircle,
              color: isActive ? Colors.red : Colors.grey,
            ),
            onPressed: isActive ? onPressed : null,
          )
      ],
    );
  }
}
