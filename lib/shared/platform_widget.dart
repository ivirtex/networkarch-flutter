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
        return androidBuilder!(context);
      case TargetPlatform.iOS:
        return iosBuilder!(context);
      default:
        throw 'Unexpected platform $defaultTargetPlatform';
    }
  }
}
