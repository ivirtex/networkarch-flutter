// Flutter imports:
import 'package:flutter/material.dart';

class ListCircularProgressIndicator extends StatelessWidget {
  const ListCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16.0,
      width: 16.0,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 3.0,
      ),
    );
  }
}
