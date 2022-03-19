// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    Key? key,
    this.child,
    this.header,
    this.footer,
    this.margin = const EdgeInsets.only(bottom: 10.0),
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final Widget? child;
  final String? header;
  final String? footer;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;
    // Scaling for the blend value, used to tune the look a bit.
    final int blendFactor = isDark ? 3 : 2;

    // start with no extra blend on card, assume it is bit different from
    // scaffold background where this Card is designed to be placed.
    Color cardColor = theme.cardColor;
    // If card or its header color, is equal to scaffold background, we will
    // adjust both and make them more primary tinted. This happens e.g. when we
    // use not blend level, or with the all level blend mode. In this
    // design we want the Card on the scaffold to always have a slightly
    // different background color from scaffold background where it is placed,
    // not necessarily a lot, but always a bit at least.
    if (cardColor == theme.scaffoldBackgroundColor) {
      cardColor = Color.alphaBlend(
        scheme.primary.withAlpha(blendFactor * 4),
        cardColor,
      );
    }
    // If it was header color that was equal, the adjustment on card, may
    // have caused card body to become equal to scaffold background, let's
    // check for it and adjust only it once again if it happened. Very unlikely
    // that this happens, but it is possible.
    if (cardColor == theme.scaffoldBackgroundColor) {
      cardColor = Color.alphaBlend(
        scheme.primary.withAlpha(blendFactor * 2),
        cardColor,
      );
    }

    return Column(
      children: [
        if (header != null) SmallDescription(child: header!),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: cardColor,
          margin: margin,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
        if (footer != null) SmallDescription(child: footer!),
      ],
    );
  }
}
