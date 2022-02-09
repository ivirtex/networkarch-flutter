// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus(
    this.state, {
    required this.connectionChecker,
    Key? key,
  }) : super(key: key);

  final NetworkStatusState state;
  final bool Function() connectionChecker;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20.0;

    if (state is NetworkStatusUpdate || state is NetworkStatusUpdateWithExtIP) {
      final isNetworkConnected = connectionChecker();

      return Row(
        children: [
          Text(
            isNetworkConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: isNetworkConnected ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(width: 5.0),
          Icon(
            isNetworkConnected ? Icons.check_circle : Icons.cancel,
            size: iconSize,
            color: isNetworkConnected ? Colors.green : Colors.red,
          ),
        ],
      );
    } else if (state is NetworkStatusUpdateFailure) {
      return Row(
        children: const [
          Text(
            'Error',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 5.0),
          Icon(
            Icons.cancel,
            size: iconSize,
          ),
        ],
      );
    } else {
      return Row(
        children: const [
          Text(
            'Checking connection...',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 5.0),
          SizedBox(
            height: 10.0,
            width: 10.0,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      );
    }
  }
}
