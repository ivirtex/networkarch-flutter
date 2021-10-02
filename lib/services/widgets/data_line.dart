// Flutter imports:
import 'package:flutter/material.dart';

class DataLine extends StatelessWidget {
  const DataLine({
    required this.textL,
    required this.textR,
    Key? key,
  }) : super(key: key);

  final Widget textL;
  final Widget? textR;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        textL,
        const Spacer(),
        textR ?? const Text('N/A'),
      ],
    );
  }
}
