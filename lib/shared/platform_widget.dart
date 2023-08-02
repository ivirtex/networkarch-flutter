// Flutter imports:
import 'package:flutter/material.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    this.androidBuilder,
    this.iosBuilder,
    super.key,
  });

  final WidgetBuilder? androidBuilder;
  final WidgetBuilder? iosBuilder;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        return iosBuilder?.call(context) ?? const SizedBox.shrink();
      case TargetPlatform.android:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return androidBuilder?.call(context) ?? const SizedBox.shrink();
    }
  }
}
