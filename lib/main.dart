// Flutter imports:
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:network_arch/theme/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/app.dart';
import 'package:network_arch/constants.dart';
import 'package:network_arch/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/ip_geo_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/models/toast_notification_model.dart';
import 'package:network_arch/models/wake_on_lan_model.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/screens/screens.dart';
import 'package:network_arch/simple_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
      .whenComplete(() async {
    final PingRepository pingRepository = PingRepository();
    final LanScannerRepository lanScannerRepository = LanScannerRepository();

    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );

    await storage.clear();

    HydratedBlocOverrides.runZoned(
      () async {
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => WakeOnLanModel()),
              ChangeNotifierProvider(create: (context) => PermissionsModel()),
              ChangeNotifierProvider(create: (context) => IPGeoModel()),
              Provider(create: (context) => ConnectivityModel()),
              Provider(create: (context) => ToastNotificationModel()),
            ],
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(value: pingRepository),
                RepositoryProvider.value(value: lanScannerRepository),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ThemeBloc(),
                  ),
                  BlocProvider(
                    create: (context) => PingBloc(pingRepository),
                  ),
                  BlocProvider(
                    create: (context) => LanScannerBloc(lanScannerRepository),
                  ),
                ],
                child: const NetworkArch(),
              ),
            ),
          ),
        );
      },
      blocObserver: SimpleBlocObserver(),
      storage: storage,
    );
  });
}

class NetworkArch extends StatelessWidget {
  const NetworkArch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //! Debug, remove in production
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          title: 'Dashboard',
          theme: Constants.lightThemeData,
          darkTheme: Constants.darkThemeData,
          themeMode: state.mode,
          builder: (context, child) {
            return CupertinoTheme(
              data: Constants.cupertinoThemeData,
              child: Material(child: child),
            );
          },
          routes: Constants.routes,
          home: const App(),
        );
      },
    );
  }
}
