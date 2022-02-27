// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

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

    Adapty.activate();

    HydratedBlocOverrides.runZoned(
      () => runApp(NetworkArch()),
      blocObserver: SimpleBlocObserver(),
      storage: storage,
    );
  });
}
