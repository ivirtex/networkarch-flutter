// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/services/widgets/cards/data_card.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    Key? key,
    required this.toolName,
    required this.toolDesc,
    this.onPressed,
  }) : super(key: key);

  final String toolName;
  final String toolDesc;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      cardChild: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toolName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
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
                backgroundColor:
                    isDarkModeOn ? Colors.grey[700] : Colors.grey[300],
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
