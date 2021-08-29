import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:network_arch/models/ip_geo_model.dart';
import 'package:network_arch/models/ip_geo_response.dart';
import 'package:network_arch/services/widgets/builders.dart';
import 'package:network_arch/services/widgets/cards/error_card.dart';
import 'package:provider/provider.dart';

class IPGeolocationView extends StatefulWidget {
  const IPGeolocationView({Key? key}) : super(key: key);

  @override
  _IPGeolocationViewState createState() => _IPGeolocationViewState();
}

class _IPGeolocationViewState extends State<IPGeolocationView> {
  final targetHostController = TextEditingController();

  late Future<IpGeoResponse> futureData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    futureData =
        context.read<IPGeoModel>().fetchDataFor(ip: targetHostController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !context.watch<IPGeoModel>().isFetching
          ? Builders.switchableAppBar(
              context: context,
              title: 'IP Geolocation',
              action: ButtonActions.start,
              isActive: true,
              onPressed: () {
                setState(() {});
              },
            )
          : Builders.switchableAppBar(
              context: context,
              title: 'IP Geolocation',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: () {},
            ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              controller: targetHostController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: 'IP address or hostname',
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            const GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: futureData,
              builder: (BuildContext context,
                  AsyncSnapshot<IpGeoResponse> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.latitude.toString());
                } else if (snapshot.hasError) {
                  return const ErrorCard(
                    message: 'Error when fetching data',
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
