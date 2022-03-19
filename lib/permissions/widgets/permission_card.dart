// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String title;
  final String description;
  final FaIcon icon;
  final PermissionStatus status;
  final VoidCallback? onPressed;

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
              if (status.isGranted)
                const Flexible(
                  flex: 2,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.circleCheck,
                      color: Colors.green,
                    ),
                  ),
                )
              else if (status.isPermanentlyDenied)
                const Flexible(
                  flex: 2,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.red,
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
