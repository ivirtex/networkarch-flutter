// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import 'package:network_arch/network_arch.dart';
import 'package:network_arch/simple_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).whenComplete(
    () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory(),
      );
      Bloc.observer = SimpleBlocObserver();

      if (Platform.isIOS) DartPingIOS.register();

      Adapty().activate();

      await Hive.initFlutter();
      await Hive.openBox<bool>('settings');
      await Hive.openBox<bool>('iap');

      await MobileAds.instance.initialize();

      await SentryFlutter.init(
        (options) {
          options
            ..tracesSampleRate = 0.2
            ..dsn = kReleaseMode
                ? 'https://5d6f627c688b407e96c3d26d2df7457c@o923305.ingest.sentry.io/6238035'
                : '';
        },
        appRunner: () => runApp(NetworkArch()),
      );
    },
  );
}
