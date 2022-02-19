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

class PermissionsView extends StatefulWidget {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  bool _isLocationPermissionGranted = false;
  bool _isPhoneStatePermissionGranted = false;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        if (state is PermissionsStatusChange) {
          state.status == PermissionStatus.granted
              ? Constants.showPermissionGrantedNotification(context)
              : Constants.showPermissionDefaultNotification(context);

          if (state.permission == Permission.locationWhenInUse) {
            setState(() {
              _isLocationPermissionGranted =
                  state.status == PermissionStatus.granted;
            });
          } else if (state.permission == Permission.phone) {
            setState(() {
              _isPhoneStatePermissionGranted =
                  state.status == PermissionStatus.granted;
            });
          }
        }
      },
      child: Column(
        children: [
          PermissionCard(
            title: 'Location',
            description: Constants.locationPermissionDesc,
            icon: const FaIcon(FontAwesomeIcons.locationArrow),
            isGranted: _isLocationPermissionGranted,
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
                isGranted: _isPhoneStatePermissionGranted,
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
      ),
    );
  }
}
