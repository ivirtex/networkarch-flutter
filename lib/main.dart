// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/app.dart';
import 'package:network_arch/constants.dart';
import 'package:network_arch/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/ip_geo_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
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

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).whenComplete(() {
    final PingRepository pingRepository = PingRepository();
    final LanScannerRepository lanScannerRepository = LanScannerRepository();

    BlocOverrides.runZoned(
      () {
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
                    create: (context) => PingBloc(pingRepository),
                  ),
                  BlocProvider(
                    create: (context) => LanScannerBloc(lanScannerRepository),
                  ),
                ],
                child: EasyDynamicThemeWidget(
                  child: const NetworkArch(),
                ),
              ),
            ),
          ),
        );
      },
      blocObserver: SimpleBlocObserver(),
    );
  });
}

class NetworkArch extends StatelessWidget {
  const NetworkArch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //! Debug, remove in production
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      title: 'Dashboard',
      theme: Constants.themeDataLight,
      darkTheme: Constants.themeDataDark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      builder: (context, child) {
        return CupertinoTheme(
          data: Constants.cupertinoThemeData,
          child: Material(child: child),
        );
      },
      routes: Constants.routes,
      home: const App(),
    );
  }
}
