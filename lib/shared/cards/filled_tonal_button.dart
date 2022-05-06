// Flutter imports:
import 'package:flutter/material.dart';

class FilledTonalButton extends StatelessWidget {
  const FilledTonalButton({
    required this.child,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Foreground color
        onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
        // Background color
        primary: Theme.of(context).colorScheme.secondaryContainer,
      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
      onPressed: onPressed,
      child: child,
    );
  }
}
