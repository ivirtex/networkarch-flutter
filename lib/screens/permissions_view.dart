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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permissions',
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataCard(
            color: isDarkModeOn ? Colors.grey[800] : Colors.grey[200],
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
                        },
                        child: const Text('Request'))
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            iconSize: 50,
            icon: const FaIcon(
              FontAwesomeIcons.arrowCircleRight,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
