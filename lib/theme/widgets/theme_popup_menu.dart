// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        for (int i = 0; i < Themes.schemesListWithDynamic.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: ListTile(
              leading: Icon(
                Icons.lens,
                color: isLight
                    ? Themes.schemesListWithDynamic[i].light.primary
                    : Themes.schemesListWithDynamic[i].dark.primary,
                size: 35,
              ),
              title: Text(Themes.schemesListWithDynamic[i].name),
            ),
          ),
      ],
      child: ListTile(
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
        title: Text(
          '${Themes.schemesListWithDynamic[schemeIndex].name} color scheme',
        ),
        subtitle: Text(Themes.schemesListWithDynamic[schemeIndex].description),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.arrow_downward_rounded,
              color: colorScheme.primary,
            ),
            Icon(
              Icons.lens_outlined,
              color: colorScheme.primary,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
