// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:network_arch/home.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/package_info/package_info.dart';
import 'package:network_arch/permissions/permissions.dart';
import 'package:network_arch/theme/theme.dart';
import 'helpers/helpers.dart';

class MockPermissionsBloc extends MockBloc<PermissionsEvent, PermissionsState>
    implements PermissionsBloc {}

class MockNetworkStatusBloc
    extends MockBloc<NetworkStatusEvent, NetworkStatusState>
    implements NetworkStatusBloc {}

class MockPackageInfoCubit extends MockCubit<PackageInfoState>
    implements PackageInfoCubit {}

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

void main() {
  late PermissionsBloc permissionsBloc;
  late NetworkStatusBloc networkStatusBloc;
  late PackageInfoCubit packageInfoCubit;
  late ThemeBloc themeBloc;

  late Box<bool> settingsBox;
  late Box<bool> iapBox;

  setUpAll(() async {
    final testingPath = p.join(Directory.current.path, 'test', 'hive_temp');
    Hive.init(testingPath);
    settingsBox = await Hive.openBox<bool>('settings');
    iapBox = await Hive.openBox<bool>('iap');

    permissionsBloc = MockPermissionsBloc();
    when(() => permissionsBloc.state).thenReturn(const PermissionsState());

    networkStatusBloc = MockNetworkStatusBloc();
    when(() => networkStatusBloc.state).thenReturn(const NetworkStatusState());

    packageInfoCubit = MockPackageInfoCubit();
    when(() => packageInfoCubit.state).thenReturn(PackageInfoInitial());
    when(() => packageInfoCubit.fetchPackageInfo())
        .thenAnswer((_) async => PackageInfoLoadInProgress());

    themeBloc = MockThemeBloc();
    when(() => themeBloc.state)
        .thenReturn(const ThemeState(scheme: CustomFlexScheme.brandBlue));
  });
  group('Home', () {
    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: permissionsBloc,
          ),
          BlocProvider.value(
            value: networkStatusBloc,
          ),
          BlocProvider.value(
            value: packageInfoCubit,
          ),
          BlocProvider.value(
            value: themeBloc,
          ),
        ],
        child: const Home(),
      );
    }

    testWidgets('constructs and renders correctly', (tester) async {
      await tester.runAsync(
        () => settingsBox.put('hasIntroductionBeenShown', true),
      );

      await tester.pumpApp(buildSubject());

      expect(find.byType(Home), findsOneWidget);
    });
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });
}
