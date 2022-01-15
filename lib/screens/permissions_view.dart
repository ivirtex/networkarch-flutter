// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/models/toast_notification_model.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class PermissionsView extends StatefulWidget {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  void goToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void initState() {
    super.initState();

    context.read<ToastNotificationModel>().fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

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
              onPressed: context
                          .watch<PermissionsModel>()
                          .prefs!
                          .getBool('hasLocationPermissionsBeenRequested') ??
                      false
                  ? () => goToDashboard(context)
                  : null,
              child: const Text('Continue'),
            ),
          )
        ],
        body: _buildBody(isDarkModeOn, context),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permissions',
        ),
        iconTheme: Theme.of(context).iconTheme,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context
                    .watch<PermissionsModel>()
                    .prefs!
                    .getBool('hasLocationPermissionsBeenRequested') ??
                false
            ? () => goToDashboard(context)
            : null,
        backgroundColor: context
                    .watch<PermissionsModel>()
                    .prefs!
                    .getBool('hasLocationPermissionsBeenRequested') ??
                false
            ? Colors.blue
            : Colors.grey,
        child: const FaIcon(FontAwesomeIcons.arrowRight),
      ),
      body: _buildBody(isDarkModeOn, context),
    );
  }

  Widget _buildBody(bool isDarkModeOn, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataCard(
            child: Consumer<PermissionsModel>(
              builder: (_, PermissionsModel model, __) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: model.locationStatusIcon,
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
                          )
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final PermissionStatus status =
                            await Permission.locationWhenInUse.request();

                        final toastInstance =
                            context.read<ToastNotificationModel>().fToast;

                        model.setLocationStatusIcon(status);

                        switch (status) {
                          case PermissionStatus.granted:
                            Constants.showToast(
                              toastInstance,
                              Constants.permissionGrantedToast,
                            );
                            break;
                          case PermissionStatus.denied:
                          case PermissionStatus.permanentlyDenied:
                            Constants.showToast(
                              toastInstance,
                              Constants.permissionDeniedToast,
                            );
                            break;
                          default:
                            Constants.showToast(
                              toastInstance,
                              Constants.permissionDefaultToast,
                            );
                            break;
                        }

                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool(
                          'hasLocationPermissionsBeenRequested',
                          true,
                        );
                      },
                      child: const Text('Request'),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
