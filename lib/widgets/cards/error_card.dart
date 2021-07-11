// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/widgets/cards/data_card.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      color: isDarkModeOn ? Colors.grey[800] : Colors.grey[200],
      cardChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.timesCircle,
              color: Colors.red,
              size: 25,
            ),
            SizedBox(height: 10),
            Text(
              message ?? Constants.defaultError,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
