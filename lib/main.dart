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
import 'package:network_arch/networkarch.dart';
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
    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );

    await Hive.initFlutter();
    await Hive.openBox('settings');
    await Hive.openBox('iap');

    Adapty.activate();
    MobileAds.instance.initialize();
    if (Platform.isIOS) DartPingIOS.register();

    final purchaserInfo = await Adapty.getPurchaserInfo(forceUpdate: true);
    Hive.box('iap').put(
      'isPremiumGranted',
      purchaserInfo.accessLevels['premium']?.isActive ?? false,
    );

    HydratedBlocOverrides.runZoned(
      () async {
        await SentryFlutter.init(
          (options) => {
            options.tracesSampleRate = 0.2,
            options.dsn =
                'https://5d6f627c688b407e96c3d26d2df7457c@o923305.ingest.sentry.io/6238035',
          },
          appRunner: () => runApp(NetworkArch()),
        );
      },
      blocObserver: kDebugMode ? SimpleBlocObserver() : null,
      storage: storage,
    );
  });
}
