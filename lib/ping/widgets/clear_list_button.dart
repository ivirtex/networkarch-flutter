// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/theme.dart';

class ClearListButton extends StatelessWidget {
  const ClearListButton({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Clear list'),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(12.0),
      borderRadius: BorderRadius.circular(10.0),
      onPressed: onPressed,
      child: const Text('Clear list'),
    );
  }
}
