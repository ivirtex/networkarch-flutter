import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:network_arch/widgets/data_card.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    Key key,
    this.isDarkTheme,
    this.toolName,
    this.toolDesc,
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
                    color: Colors.grey[400],
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
                color: isDarkTheme == true ? Colors.white : Colors.black,
              ),
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
