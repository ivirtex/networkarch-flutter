// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Widget used to change the used FlexSchemeData index in example 4.
class ThemePopupMenu extends StatelessWidget {
  const ThemePopupMenu({
    required this.schemeIndex,
    required this.onChanged,
    this.contentPadding,
    Key? key,
  }) : super(key: key);
  final int schemeIndex;
  final ValueChanged<int> onChanged;
  // Defaults to 16, like ListTile does.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final ColorScheme colorScheme = theme.colorScheme;

    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        for (int i = 0; i < FlexColor.schemes.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: ListTile(
              leading: Icon(
                Icons.lens,
                color: isLight
                    ? FlexColor.schemesList[i].light.primary
                    : FlexColor.schemesList[i].dark.primary,
                size: 35,
              ),
              title: Text(FlexColor.schemesList[i].name),
            ),
          ),
      ],
      child: ListTile(
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          '${FlexColor.schemesList[schemeIndex].name} color scheme',
        ),
        subtitle: Text(FlexColor.schemesList[schemeIndex].description),
        trailing: Icon(
          Icons.lens,
          color: colorScheme.primary,
          size: 40,
        ),
      ),
    );
  }
}
