import 'package:flutter/material.dart';

class DataLine extends StatelessWidget {
  const DataLine({
    this.textL,
    this.textR,
  });

  final String textL;
  final String textR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          Text(textL),
          Spacer(),
          Text(textR),
        ],
      ),
    );
  }
}
