// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/package_info/package_info.dart';
import 'package:network_arch/shared/cards/cards.dart';
import 'package:network_arch/shared/list_text_line.dart';
import 'package:network_arch/shared/rounded_list.dart';

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
        }

        return const SizedBox();
      },
    );
  }
}
