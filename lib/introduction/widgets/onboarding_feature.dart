// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/cards/cards.dart';

class OnboardingFeature extends StatelessWidget {
  const OnboardingFeature({
    required this.icon,
    required this.iosIcon,
    required this.title,
    required this.description,
    this.cardColor,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final IconData iosIcon;
  final String title;
  final String description;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Icon(
            Theme.of(context).platform == TargetPlatform.iOS ? iosIcon : icon,
            size: 36.0,
          ),
          const SizedBox(width: Constants.listSpacing),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  description,
                  style: isDarkModeOn
                      ? Constants.descStyleDark
                      : Constants.descStyleLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
