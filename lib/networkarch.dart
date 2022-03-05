// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:feedback/feedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/home.dart';
import 'package:network_arch/ip_geo/ip_geo.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/package_info/cubit/package_info_cubit.dart';
import 'package:network_arch/permissions/permissions.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/theme.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';
import 'package:network_arch/whois/whois.dart';

class NetworkArch extends StatelessWidget {
  NetworkArch({Key? key}) : super(key: key);

  final NetworkStatusRepository networkStatusRepository =
      NetworkStatusRepository();
  final pingRepository = PingRepository();
  final lanScannerRepository = LanScannerRepository();
  final ipGeoRepository = IpGeoRepository();
  final whoisRepository = WhoisRepository();
  final dnsLookupRepository = DnsLookupRepository();

  @override
  Widget build(BuildContext context) {
    //! Debug, remove in production
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return BetterFeedback(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: networkStatusRepository),
          RepositoryProvider.value(value: pingRepository),
          RepositoryProvider.value(value: lanScannerRepository),
          RepositoryProvider.value(value: ipGeoRepository),
          RepositoryProvider.value(value: whoisRepository),
          RepositoryProvider.value(value: dnsLookupRepository),
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
              create: (context) => PackageInfoCubit(),
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
            ),
            BlocProvider(
              create: (context) => IpGeoBloc(ipGeoRepository),
            ),
            BlocProvider(
              create: (context) => WhoisBloc(whoisRepository),
            ),
            BlocProvider(
              create: (context) => DnsLookupBloc(dnsLookupRepository),
            ),
          ],
          child: PlatformWidget(
            androidBuilder: _buildAndroid,
            iosBuilder: _buildIOS,
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          navigatorObservers: [
            SentryNavigatorObserver(),
          ],
          title: Constants.appName,
          theme: Themes.lightThemeData,
          darkTheme: Themes.darkThemeData,
          themeMode: state.mode,
          routes: Constants.routes,
          home: const Home(),
        );
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return CupertinoApp(
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          navigatorObservers: [
            SentryNavigatorObserver(),
          ],
          title: Constants.appName,
          theme: Themes.cupertinoThemeData,
          routes: Constants.routes,
          home: const Home(),
        );
      },
    );
  }
}
