// Flutter imports:
import 'package:flutter/material.dart';

class ListCircularProgressIndicator extends StatelessWidget {
  const ListCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 3,
      ),
    );
  }
}
