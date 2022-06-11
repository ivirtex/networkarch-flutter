// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

class IOSThemeSwitcher extends StatefulWidget {
  const IOSThemeSwitcher({Key? key}) : super(key: key);

  @override
  State<IOSThemeSwitcher> createState() => _IOSThemeSwitcherState();
}

class _IOSThemeSwitcherState extends State<IOSThemeSwitcher> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedThemeMode = context.read<ThemeBloc>().state.mode;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      groupValue: _selectedThemeMode,
      onValueChanged: (ThemeMode? mode) {
        if (mode != null) {
          setState(() {
            _selectedThemeMode = mode;

            context.read<ThemeBloc>().add(
                  ThemeModeChangedEvent(
                    themeMode: mode,
                  ),
                );
          });
        }
      },
      children: const <ThemeMode, Widget>{
        ThemeMode.light: Text('Light'),
        ThemeMode.dark: Text('Dark'),
        ThemeMode.system: Text('System'),
      },
    );
  }
}
