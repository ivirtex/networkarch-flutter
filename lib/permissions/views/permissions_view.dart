// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/permissions/bloc/permissions_bloc.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        if (state is PermissionsLocationStatusChange) {
          state.status == PermissionStatus.granted
              ? Constants.showPermissionGrantedNotification(context)
              : Constants.showPermissionDefaultNotification(context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataCard(
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FaIcon(FontAwesomeIcons.locationArrow),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        Constants.locationPermissionDesc,
                        style: isDarkModeOn
                            ? Constants.descStyleDark
                            : Constants.descStyleLight,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<PermissionsBloc>()
                        .add(const PermissionsLocationRequested());
                  },
                  child: const Text('Request'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
