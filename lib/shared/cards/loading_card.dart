// Flutter imports:
import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
