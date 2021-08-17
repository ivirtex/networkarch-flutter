// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/services/widgets/cards/data_card.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 37),
        child: Column(
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}