// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/theme/theme.dart';

class AndroidThemeSwitcher extends StatelessWidget {
  const AndroidThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();

    return Column(
      children: [
        const SmallDescription(text: 'Theme settings'),
        DataCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: FlexThemeModeSwitch(
                  themeMode: themeBloc.state.mode,
                  onThemeModeChanged: (mode) {
                    themeBloc.add(ThemeModeChangedEvent(themeMode: mode));
                  },
                  flexSchemeData: Themes
                      .schemesListWithDynamic[themeBloc.state.scheme.index],
                  optionButtonBorderRadius: 10.0,
                ),
              ),
              ThemePopupMenu(
                schemeIndex: themeBloc.state.scheme.index,
                onChanged: (index) async {
                  // Await for popup menu to close (to avoid jank)
                  await Future.delayed(
                    const Duration(milliseconds: 300),
                  );

                  themeBloc.add(
                    ThemeSchemeChangedEvent(
                      scheme: CustomFlexScheme.values[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
