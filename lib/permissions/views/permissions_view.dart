// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/permissions/bloc/permissions_bloc.dart';
import 'package:network_arch/permissions/widgets/usage_desc.dart';
import 'package:network_arch/permissions/widgets/widgets.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        if (state.latestRequested == Permission.locationWhenInUse) {
          if (state.locationStatus == PermissionStatus.granted) {
            Constants.showPermissionGrantedNotification(context);
          } else if (state.locationStatus ==
              PermissionStatus.permanentlyDenied) {
            Constants.showPermissionDeniedNotification(context);
          } else {
            Constants.showPermissionDefaultNotification(context);
          }
        }

        if (state.latestRequested == Permission.phone) {
          if (state.phoneStateStatus == PermissionStatus.granted) {
            Constants.showPermissionGrantedNotification(context);
          } else if (state.phoneStateStatus ==
              PermissionStatus.permanentlyDenied) {
            Constants.showPermissionDeniedNotification(context);
          } else {
            Constants.showPermissionDefaultNotification(context);
          }
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            PermissionCard(
              title: 'Location',
              description: Constants.locationPermissionDesc,
              icon: const FaIcon(FontAwesomeIcons.locationArrow),
              status: state.locationStatus ?? PermissionStatus.denied,
              onPressed: () {
                context
                    .read<PermissionsBloc>()
                    .add(const PermissionsLocationRequested());
              },
            ),
            // iOS doesn't need this permission
            PlatformWidget(
              androidBuilder: (_) {
                return PermissionCard(
                  title: 'Phone',
                  description: Constants.phoneStatePermissionDesc,
                  icon: const FaIcon(FontAwesomeIcons.phoneAlt),
                  status: state.phoneStateStatus ?? PermissionStatus.denied,
                  onPressed: () {
                    context
                        .read<PermissionsBloc>()
                        .add(const PermissionsPhoneStateRequested());
                  },
                );
              },
            ),
            const UsageDesc(),
          ],
        );
      },
    );
  }
}
