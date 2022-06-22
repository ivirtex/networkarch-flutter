// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/shared.dart';

class ClearListButton extends StatelessWidget {
  const ClearListButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return AdaptiveButton(
      buttonType: ButtonType.filledTonal,
      onPressed: onPressed,
      child: const Text('Clear list'),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10),
      onPressed: onPressed,
      child: const Text('Clear list'),
    );
  }
}
