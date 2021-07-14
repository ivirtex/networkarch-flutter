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
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      color: isDarkModeOn ? Colors.grey[800] : Colors.grey[200],
      cardChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(
              FontAwesomeIcons.timesCircle,
              color: Colors.red,
              size: 25,
            ),
            const SizedBox(height: 10),
            Text(
              message ?? Constants.defaultError,
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
