// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/widgets/cards/data_card.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    Key key,
    @required this.isDarkTheme,
    @required this.toolName,
    @required this.toolDesc,
    this.onPressed,
  }) : super(key: key);

  final bool isDarkTheme;
  final String toolName;
  final String toolDesc;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      color: isDarkTheme ? Colors.grey[800] : Colors.grey[200],
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  toolDesc,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Flexible(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: CircleBorder(),
                primary: Colors.white,
                backgroundColor:
                    isDarkTheme ? Colors.grey[700] : Colors.grey[300],
              ),
              child: FaIcon(
                FontAwesomeIcons.arrowCircleRight,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
