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
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/ip_geo_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/models/ping_model.dart';
import 'package:network_arch/models/toast_notification_model.dart';
import 'package:network_arch/models/wake_on_lan_model.dart';
import 'package:network_arch/ping/bloc/ping_bloc.dart';
import 'package:network_arch/ping/repository/ping_repository.dart';
import 'package:network_arch/screens/screens.dart';
import 'ping/ping.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).whenComplete(() {
    final PingRepository pingRepository = PingRepository();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LanScannerModel()),
          ChangeNotifierProvider(create: (context) => WakeOnLanModel()),
          ChangeNotifierProvider(create: (context) => PermissionsModel()),
          ChangeNotifierProvider(create: (context) => IPGeoModel()),
          Provider(create: (context) => ConnectivityModel()),
          Provider(create: (context) => ToastNotificationModel()),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: pingRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PingBloc(pingRepository),
              )
            ],
            child: EasyDynamicThemeWidget(
              child: const NetworkArch(),
            ),
          ),
        ),
      ),
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
      routes: {
        '/permissions': (context) => const PermissionsView(),
        '/wifi': (context) => const WiFiDetailView(),
        '/cellular': (context) => const CellularDetailView(),
        '/tools/ping': (context) => const PingView(),
        // '/tools/lan': (context) => const LanScannerView(),
        '/tools/wol': (context) => const WakeOnLanView(),
        // '/tools/ip_geo': (context) => const IPGeolocationView(),
      },
      home: const App(),
    );
  }
}
