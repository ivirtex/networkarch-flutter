// Flutter imports:
import 'package:flutter/material.dart';
import 'package:network_arch/constants.dart';

class DataLine extends StatelessWidget {
  const DataLine({
    required this.textL,
    required this.textR,
    this.padding,
    Key? key,
  }) : super(key: key);

  final Widget textL;
  final Widget? textR;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? Constants.listPadding,
      child: Row(
        children: [
          textL,
          const Spacer(),
          textR ?? const Text('N/A'),
        ],
      ),
    );
  }
}
