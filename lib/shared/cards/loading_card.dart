// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/cards/cards.dart';
import 'package:network_arch/shared/list_circular_progress_indicator.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DataCard(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Spacer(),
          ListCircularProgressIndicator(),
          Spacer(),
        ],
      ),
    );
  }
}
