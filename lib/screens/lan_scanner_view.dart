// // Dart imports:
// import 'dart:io';

// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:provider/provider.dart';

// // Project imports:
// import 'package:network_arch/models/animated_list_model.dart';
// import 'package:network_arch/models/lan_scanner_model.dart';
// import 'package:network_arch/shared/shared_widgets.dart';

// class LanScannerView extends StatefulWidget {
//   const LanScannerView({Key? key}) : super(key: key);

//   @override
//   _LanScannerViewState createState() => _LanScannerViewState();
// }

// class _LanScannerViewState extends State<LanScannerView> {
//   final _listKey = GlobalKey<AnimatedListState>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     context.read<LanScannerModel>().hosts = AnimatedListModel<InternetAddress>(
//       listKey: _listKey,
//       removedItemBuilder: _buildItem,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: context.watch<LanScannerModel>().getIsScannerRunning()
//           ? Builders.switchableAppBar(
//               context: context,
//               title: 'LAN Scanner',
//               action: ButtonActions.stop,
//               isActive: true,
//               onPressed: () {
//                 context
//                     .read<LanScannerModel>()
//                     .handleStopButtonPressed(context);
//               },
//             )
//           : Builders.switchableAppBar(
//               context: context,
//               title: 'LAN Scanner',
//               action: ButtonActions.start,
//               isActive: true,
//               onPressed: () {
//                 context
//                     .read<LanScannerModel>()
//                     .handleStartButtonPressed(context);
//               },
//             ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Consumer<LanScannerModel>(
//               builder: (context, value, child) {
//                 return LinearProgressIndicator(
//                   value: value.scanProgress,
//                 );
//               },
//             ),
//           ),
//           AnimatedList(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             key: _listKey,
//             initialItemCount: context.read<LanScannerModel>().hosts.length,
//             itemBuilder: (context, index, animation) {
//               return _buildItem(
//                 context,
//                 animation,
//                 context.read<LanScannerModel>().hosts[index],
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   FadeTransition _buildItem(
//     BuildContext context,
//     Animation<double> animation,
//     InternetAddress item,
//   ) {
//     final model = context.read<LanScannerModel>();

//     return FadeTransition(
//       opacity: animation.drive(model.hosts.fadeTween),
//       child: SlideTransition(
//         position: animation.drive(model.hosts.slideTween),
//         child: Card(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//           child: ListTile(
//             leading: const StatusCard(
//               color: Colors.greenAccent,
//               text: 'Online',
//             ),
//             title: Text(item.address),
//             trailing: TextButton(
//               onPressed: () {
//                 Navigator.of(context).popAndPushNamed(
//                   '/tools/ping',
//                   arguments: item.address,
//                 );
//               },
//               child: const Text('Ping'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
