// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    required this.text,
    this.androidIcon = FontAwesomeIcons.arrowCircleRight,
    this.cupertinoIcon = CupertinoIcons.chevron_right,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final IconData? androidIcon;
  final IconData? cupertinoIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  TextButton _buildAndroid(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: Constants.getPlatformBtnColor(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Text(
            text,
            style: TextStyle(
              color: Constants.getPlatformTextColor(context),
            ),
          ),
          FaIcon(
            androidIcon,
            color: Constants.getPlatformIconColor(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      onPressed: onPressed,
      color: Constants.getPlatformBtnColor(context),
      borderRadius: BorderRadius.circular(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Text(
            text,
            style: TextStyle(
              color: isDarkModeOn ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            cupertinoIcon,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.label,
              context,
            ),
          ),
        ],
      ),
    );
  }
}
