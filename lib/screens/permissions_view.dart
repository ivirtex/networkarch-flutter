import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/widgets/shared_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// TODO: Fix this

class PermissionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    void goToDashboard() {
      Navigator.of(context).pushReplacementNamed('/');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permissions',
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            context.watch<PermissionsModel>().hasLocationPermissionBeenRequested
                ? goToDashboard
                : null,
        backgroundColor:
            context.watch<PermissionsModel>().hasLocationPermissionBeenRequested
                ? Colors.blue
                : Colors.grey,
        child: const FaIcon(FontAwesomeIcons.arrowRight),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataCard(
            cardChild: Consumer<PermissionsModel>(
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

                          model.setLocationStatusIcon(status);

                          switch (status) {
                            case PermissionStatus.granted:
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.permissionGrantedSnackBar);
                              break;
                            case PermissionStatus.denied:
                            case PermissionStatus.permanentlyDenied:
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.permissionDeniedSnackBar);
                              break;
                            default:
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.permissionDefaultSnackBar);
                              break;
                          }

                          model.hasLocationPermissionBeenRequested = true;
                        },
                        child: const Text('Request'))
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
