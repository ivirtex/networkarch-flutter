// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:network_arch/app.dart';
import 'package:network_arch/constants.dart';
import 'package:network_arch/ip_geo/bloc/ip_geo_bloc.dart';
import 'package:network_arch/ip_geo/repository/ip_geo_repository.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/permissions/permissions.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/simple_bloc_observer.dart';
import 'package:network_arch/theme/theme.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';
import 'package:network_arch/whois/whois.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
      .whenComplete(() async {
    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );

    await Hive.initFlutter();
    await Hive.openBox('settings');

    HydratedBlocOverrides.runZoned(
      () {
        runApp(NetworkArch());
      },
      blocObserver: SimpleBlocObserver(),
      storage: storage,
    );
  });
}

class NetworkArch extends StatelessWidget {
  NetworkArch({Key? key}) : super(key: key);

  final NetworkStatusRepository networkStatusRepository =
      NetworkStatusRepository();
  final pingRepository = PingRepository();
  final lanScannerRepository = LanScannerRepository();
  final ipGeoRepository = IpGeoRepository();
  final whoisRepository = WhoisRepository();

  @override
  Widget build(BuildContext context) {
    //! Debug, remove in production
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: networkStatusRepository),
        RepositoryProvider.value(value: pingRepository),
        RepositoryProvider.value(value: lanScannerRepository),
        RepositoryProvider.value(value: ipGeoRepository),
        RepositoryProvider.value(value: whoisRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => PermissionsBloc(),
          ),
          BlocProvider(
            create: (context) => NetworkStateBloc(networkStatusRepository),
          ),
          BlocProvider(
            create: (context) => PingBloc(pingRepository),
          ),
          BlocProvider(
            create: (context) => LanScannerBloc(lanScannerRepository),
          ),
          BlocProvider(
            create: (context) => WakeOnLanBloc(),
          ),
          BlocProvider(
            create: (context) => IpGeoBloc(ipGeoRepository),
          ),
          BlocProvider(
            create: (context) => WhoisBloc(whoisRepository),
          ),
        ],
        child: PlatformWidget(
          androidBuilder: _buildAndroid,
          iosBuilder: _buildIOS,
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          title: Constants.appName,
          theme: Themes.lightThemeData,
          darkTheme: Themes.darkThemeData,
          themeMode: state.mode,
          routes: Constants.routes,
          home: const App(),
        );
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return CupertinoApp(
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          title: Constants.appName,
          theme: Themes.cupertinoThemeData,
          routes: Constants.routes,
          home: const App(),
        );
      },
    );
  }
}
