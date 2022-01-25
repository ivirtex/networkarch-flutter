import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_arch/utils/enums.dart';

class CupertinoActionAppBar extends StatelessWidget {
  const CupertinoActionAppBar(
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
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      stretch: true,
      border: null,
      largeTitle: Text(title),
      trailing: action == ButtonActions.start
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? onPressed : null,
              child: const Icon(
                CupertinoIcons.play,
                color: CupertinoColors.activeGreen,
              ),
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? onPressed : null,
              child: const FaIcon(
                CupertinoIcons.stop,
                color: CupertinoColors.destructiveRed,
              ),
            ),
    );
  }
}