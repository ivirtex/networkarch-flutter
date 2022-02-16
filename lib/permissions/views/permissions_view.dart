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
        ],
      ),
    );
  }
}

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
    this.isGranted = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final String description;
  final FaIcon icon;
  final VoidCallback? onPressed;
  final bool isGranted;

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataCard(
          child: Row(
            children: [
              Flexible(
                child: Center(child: icon),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      description,
                      style: isDarkModeOn
                          ? Constants.descStyleDark
                          : Constants.descStyleLight,
                    ),
                  ],
                ),
              ),
              if (isGranted)
                const Flexible(
                  flex: 2,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      color: Colors.green,
                    ),
                  ),
                )
              else
                Flexible(
                  flex: 2,
                  child: Center(
                    child: TextButton(
                      onPressed: onPressed,
                      child: const Text('Request'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
