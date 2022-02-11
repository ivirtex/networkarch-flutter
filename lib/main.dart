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
import 'package:network_arch/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/permissions/bloc/permissions_bloc.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/platform_widget.dart';
import 'package:network_arch/simple_bloc_observer.dart';
import 'package:network_arch/theme/theme.dart';
import 'package:network_arch/wake_on_lan/bloc/wake_on_lan_bloc.dart';

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
  final PingRepository pingRepository = PingRepository();
  final LanScannerRepository lanScannerRepository = LanScannerRepository();

  @override
  Widget build(BuildContext context) {
    //! Debug, remove in production
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: networkStatusRepository),
        RepositoryProvider.value(value: pingRepository),
        RepositoryProvider.value(value: lanScannerRepository),
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
            create: (context) => NetworkStatusBloc(networkStatusRepository),
          ),
          BlocProvider(
            create: (context) => PingBloc(pingRepository),
          ),
          BlocProvider(
            create: (context) => LanScannerBloc(lanScannerRepository),
          ),
          BlocProvider(
            create: (context) => WakeOnLanBloc(),
          )
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
          theme: Constants.lightThemeData,
          darkTheme: Constants.darkThemeData,
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
          theme: Constants.cupertinoThemeData,
          routes: Constants.routes,
          home: const App(),
        );
      },
    );
  }
}
