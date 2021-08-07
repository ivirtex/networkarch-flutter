// Flutter imports:
import 'package:flutter/material.dart';

class DataLine extends StatelessWidget {
  const DataLine({
    required this.textL,
    required this.textR,
  });

  final String textL;
  final String? textR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          Text(textL),
          const Spacer(),
          Text(textR!),
        ],
      ),
    );
  }
}
