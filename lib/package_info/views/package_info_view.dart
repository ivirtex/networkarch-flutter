// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/package_info/package_info.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class PackageInfoView extends StatelessWidget {
  const PackageInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageInfoCubit, PackageInfoState>(
      builder: (context, state) {
        if (state is PackageInfoLoadInProgress) {
          return const LoadingCard();
        }

        if (state is PackageInfoLoadSuccess) {
          return PlatformWidget(
            androidBuilder: (context) {
              return RoundedList(
                header: 'About',
                footer: 'Made with ❤️ by ivirtex',
                children: [
                  ListTextLine(
                    widgetL: const Text('App name'),
                    widgetR: Text(state.packageInfo.appName),
                  ),
                  ListTextLine(
                    widgetL: const Text('Version'),
                    widgetR: Text(state.packageInfo.version),
                  ),
                ],
              );
            },
            iosBuilder: (context) {
              return CupertinoListSection.insetGrouped(
                header: const Text('About'),
                footer: const Text('Made with ❤️ by ivirtex'),
                hasLeading: false,
                children: [
                  CupertinoListTile.notched(
                    title: const Text('App name'),
                    trailing: Text(state.packageInfo.appName),
                  ),
                  CupertinoListTile.notched(
                    title: const Text('Version'),
                    trailing: Text(state.packageInfo.version),
                  ),
                ],
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
