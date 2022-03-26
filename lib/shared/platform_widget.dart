// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    this.androidBuilder,
    this.iosBuilder,
    this.windowsBuilder,
    Key? key,
  }) : super(key: key);

  final WidgetBuilder? androidBuilder;
  final WidgetBuilder? iosBuilder;
  final WidgetBuilder? windowsBuilder;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder?.call(context) ?? const SizedBox.shrink();
      case TargetPlatform.iOS:
        return iosBuilder?.call(context) ?? const SizedBox.shrink();
      case TargetPlatform.windows:
        return windowsBuilder?.call(context) ?? const SizedBox.shrink();
      default:
        return androidBuilder?.call(context) ?? const SizedBox.shrink();
    }
  }
}
