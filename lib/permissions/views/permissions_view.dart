// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/permissions/bloc/permissions_bloc.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permissions',
        ),
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          BlocConsumer<PermissionsBloc, PermissionsState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is PermissionsLocationStatusChange) {
                if (state.status.isGranted) {
                  Constants.showPermissionGrantedNotification(context);
                }
              }
            },
            builder: (context, state) {
              return TextButton(
                child: const Text('Continue'),
                onPressed: () => goToDashboard(context),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: const Text(
              'Permissions',
            ),
            trailing: CupertinoButton(
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

  void goToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/');
  }
}
