// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    required this.child,
    this.buttonType = ButtonType.text,
    this.shape,
    this.opacity,
    this.onPressed,
    super.key,
  });

  factory AdaptiveButton.filled({
    required Widget child,
    VoidCallback? onPressed,
    Key? key,
  }) {
    return AdaptiveButton(
      onPressed: onPressed,
      key: key,
      buttonType: ButtonType.filled,
      child: child,
    );
  }

  final Widget child;
  final ButtonType buttonType;
  final OutlinedBorder? shape;
  final double? opacity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: shape,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.filled:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Foreground color
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(opacity ?? 0.8),
            shape: shape,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.filledTonal:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Foreground color
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            backgroundColor: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(opacity ?? 0.5),
            shape: shape,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).copyWith(
            elevation: ButtonStyleButton.allOrNull(0),
          ),
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: shape,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          child: child,
        );
    }
  }

  Widget _buildIOS(BuildContext context) {
    switch (buttonType) {
      case ButtonType.elevated:
      case ButtonType.filledTonal:
      case ButtonType.outlined:
      case ButtonType.filled:
        return CupertinoButton.filled(
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.text:
        return CupertinoButton(
          onPressed: onPressed,
          child: child,
        );
    }
  }
}

enum ButtonType {
  elevated,
  filled,
  filledTonal,
  outlined,
  text,
}
