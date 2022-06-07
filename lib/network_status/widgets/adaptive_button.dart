// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    required this.child,
    this.androidIcon = FontAwesomeIcons.circleArrowRight,
    this.cupertinoIcon,
    this.onPressed,
    this.buttonType = ButtonType.text,
    Key? key,
  }) : super(key: key);

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
  final IconData? androidIcon;
  final IconData? cupertinoIcon;
  final VoidCallback? onPressed;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    switch (buttonType) {
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              child,
              FaIcon(
                androidIcon,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              child,
              FaIcon(
                androidIcon,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        );
    }
  }

  Widget _buildIOS(BuildContext context) {
    switch (buttonType) {
      case ButtonType.text:
        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.filled:
        return CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          onPressed: onPressed,
          child: child,
        );
    }
  }
}

enum ButtonType {
  text,
  filled,
}
