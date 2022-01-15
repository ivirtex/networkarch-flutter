// Flutter imports:
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    required this.text,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
