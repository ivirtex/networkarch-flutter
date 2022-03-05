// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    this.androidBuilder,
    this.iosBuilder,
    Key? key,
  }) : super(key: key);

  final WidgetBuilder? androidBuilder;
  final WidgetBuilder? iosBuilder;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder != null
            ? androidBuilder!(context)
            : const SizedBox();
      case TargetPlatform.iOS:
        return iosBuilder != null ? iosBuilder!(context) : const SizedBox();
      default:
        throw 'Unexpected platform $defaultTargetPlatform';
    }
  }
}
