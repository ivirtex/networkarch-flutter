// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/widgets/cards/data_card.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      color: isDarkModeOn ? Colors.grey[800] : Colors.grey[200],
      cardChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
