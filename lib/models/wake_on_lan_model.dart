// // Dart imports:
// import 'dart:async';

// // Flutter imports:
// import 'package:flutter/foundation.dart';

// // Package imports:
// import 'package:wake_on_lan/wake_on_lan.dart';

// // Project imports:
// import 'package:network_arch/models/animated_list_model.dart';
// import 'package:network_arch/utils/enums.dart';

// class WakeOnLanModel extends ChangeNotifier {
//   late String ipv4;
//   late String mac;

//   late AnimatedListModel<WolResponse> wolResponses;

//   bool areTextFieldsValid() {
//     if (MACAddress.validate(mac) && IPv4Address.validate(ipv4)) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<void> sendPacket() async {
//     if (MACAddress.validate(mac) && IPv4Address.validate(ipv4)) {
//       final MACAddress macAddress = MACAddress.from(mac);
//       final IPv4Address ipv4Address = IPv4Address.from(ipv4);
//       final WakeOnLAN wol = WakeOnLAN.from(ipv4Address, macAddress);

//       await wol.wake().then((_) {
//         // print('sent');

//         wolResponses.insert(
//           wolResponses.length,
//           WolResponse(ipv4, mac, WolStatus.success),
//         );
//       });
//     }

//     notifyListeners();
//   }
// }

// class WolResponse {
//   WolResponse(this.ipv4, this.mac, this.status);

//   final String ipv4;
//   final String mac;
//   final WolStatus status;
// }
