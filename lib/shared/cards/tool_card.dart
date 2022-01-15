// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.toolName,
    required this.toolDesc,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String toolName;
  final String toolDesc;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toolName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: isDarkModeOn ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  toolDesc,
                  style: isDarkModeOn
                      ? Constants.descStyleDark
                      : Constants.descStyleLight,
                )
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
                primary: Colors.white,
                backgroundColor: Constants.getPlatformBtnColor(context),
              ),
              onPressed: onPressed as void Function()?,
              child: FaIcon(
                FontAwesomeIcons.arrowCircleRight,
                color: isDarkModeOn ? Colors.white : Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
