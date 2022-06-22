// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/theme/themes.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    this.child,
    this.header,
    this.footer,
    this.margin = const EdgeInsets.only(bottom: 10),
    this.padding = const EdgeInsets.all(8),
  });

  final Widget? child;
  final String? header;
  final String? footer;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    // start with no extra blend on card, assume it is bit different from
    // scaffold background where this Card is designed to be placed.
    var defaultCardColor = theme.cardColor;

    if (Theme.of(context).platform == TargetPlatform.android) {
      // Scaling for the blend value, used to tune the look a bit.
      final blendFactor = isDark ? 3 : 2;

      // If card or its header color, is equal to scaffold background, we will
      // adjust both and make them more primary tinted. This happens e.g. when we
      // use not blend level, or with the all level blend mode. In this
      // design we want the Card on the scaffold to always have a slightly
      // different background color from scaffold background where it is placed,
      // not necessarily a lot, but always a bit at least.
      if (defaultCardColor == theme.scaffoldBackgroundColor) {
        defaultCardColor = Color.alphaBlend(
          scheme.primary.withAlpha(blendFactor * 6),
          defaultCardColor,
        );
      }
      // If it was header color that was equal, the adjustment on card, may
      // have caused card body to become equal to scaffold background, let's
      // check for it and adjust only it once again if it happened. Very unlikely
      // that this happens, but it is possible.
      if (defaultCardColor == theme.scaffoldBackgroundColor) {
        defaultCardColor = Color.alphaBlend(
          scheme.primary.withAlpha(blendFactor * 2),
          defaultCardColor,
        );
      }
    } else {
      defaultCardColor = Themes.iOSCardColor.resolveFrom(context);
    }

    return Column(
      children: [
        if (header != null) SmallDescription(text: header!),
        Card(
          color: defaultCardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: margin,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
        if (footer != null) SmallDescription(text: footer!),
      ],
    );
  }
}
