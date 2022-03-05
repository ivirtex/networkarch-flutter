import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: isDarkModeOn ? Colors.white : Colors.black,
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
              color: isDarkModeOn ? Colors.white : Colors.black,
            ),
          ),
          FaIcon(
            androidIcon,
            color: isDarkModeOn ? Colors.white : Colors.black,
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
