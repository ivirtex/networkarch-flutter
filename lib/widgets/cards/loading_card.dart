// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/widgets/cards/data_card.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    Key key,
    @required this.isDark,
  }) : super(key: key);

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      color: isDark ? Colors.grey[800] : Colors.grey[200],
      cardChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
