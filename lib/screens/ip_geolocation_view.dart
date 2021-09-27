// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:network_arch/services/widgets/platform_widget.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/services/widgets/shared_widgets.dart';
import '../models/ip_geo_model.dart';
import '../models/ip_geo_response.dart';
import '../services/utils/keyboard_hider.dart';
import '../services/widgets/builders.dart';
import '../services/widgets/cards/error_card.dart';

class IPGeolocationView extends StatefulWidget {
  const IPGeolocationView({Key? key}) : super(key: key);

  @override
  _IPGeolocationViewState createState() => _IPGeolocationViewState();
}

class _IPGeolocationViewState extends State<IPGeolocationView> {
  final _targetHostController = TextEditingController();

  late GoogleMapController _mapController;
  late String _darkMapStyle;

  late IPGeoModel modelProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle.loadString('assets/dark_mode_map_style.txt').then((value) {
      _darkMapStyle = value;
    });

    modelProvider = context.read<IPGeoModel>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    modelProvider.hasBeenFetchedAtLeastOnce = false;

    _targetHostController.dispose();
    _mapController.dispose();
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
                final IPGeoModel model = context.read<IPGeoModel>();

                setState(() {
                  model.isFetching = true;
                  model.hasBeenFetchedAtLeastOnce = true;
                  model.fetchDataFor(ip: _targetHostController.text);
                });

                _targetHostController.clear();
                hideKeyboard(context);
              },
            )
          : Builders.switchableAppBar(
              context: context,
              title: 'IP Geolocation',
              action: ButtonActions.stop,
              isActive: true,
              onPressed: () {
                setState(() {
                  context.watch<IPGeoModel>().isFetching = false;
                });
              },
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlatformWidget(
                androidBuilder: (context) => TextField(
                  autocorrect: false,
                  controller: _targetHostController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'IP address or hostname',
                  ),
                ),
                iosBuilder: (context) => CupertinoTextField(
                  autocorrect: false,
                  controller: _targetHostController,
                  placeholder: 'IP address or hostname',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    initialCameraPosition:
                        context.read<IPGeoModel>().startPosition,
                    markers: context.read<IPGeoModel>().markers,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;

                      if (Theme.of(context).brightness == Brightness.dark) {
                        _mapController.setMapStyle(_darkMapStyle);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: context.watch<IPGeoModel>().hasBeenFetchedAtLeastOnce,
                child: StreamBuilder<IpGeoResponse>(
                  stream: context.read<IPGeoModel>().streamOfResponses(),
                  builder: (BuildContext context,
                      AsyncSnapshot<IpGeoResponse> snapshot) {
                    context.read<IPGeoModel>().isFetching = false;

                    if (snapshot.hasData) {
                      processData(context, snapshot);

                      return buildDataList(snapshot);
                    } else if (snapshot.hasError) {
                      return const ErrorCard(
                        message: 'Error when fetching data',
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView buildDataList(AsyncSnapshot<IpGeoResponse> snapshot) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Latitude'),
            textR: Text(snapshot.data!.latitude.toString()),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Longitude'),
            textR: Text(snapshot.data!.longitude.toString()),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('City'),
            textR: Text(snapshot.data!.city ?? 'N/A'),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Country code'),
            textR: Text(snapshot.data!.countryCode ?? 'N/A'),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Country name'),
            textR: Text(snapshot.data!.countryName ?? 'N/A'),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('IP'),
            textR: Text(snapshot.data!.ip ?? 'N/A'),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Metro code'),
            textR: Text(snapshot.data!.metroCode.toString()),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Region code'),
            textR: Text(snapshot.data!.regionCode ?? 'N/A'),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Region name'),
            textR: Text(snapshot.data!.regionName ?? 'N/A'),
          ),
        ),
        DataCard(
          margin: 5,
          child: DataLine(
            textL: const Text('Time zone'),
            textR: Text(snapshot.data!.timeZone ?? 'N/A'),
          ),
        ),
      ],
    );
  }

  void processData(
      BuildContext context, AsyncSnapshot<IpGeoResponse> snapshot) {
    final pos = LatLng(snapshot.data!.latitude!, snapshot.data!.longitude!);

    context
        .read<IPGeoModel>()
        .markers
        .add(Marker(markerId: const MarkerId('IP Loc'), position: pos));

    _mapController.animateCamera(
      CameraUpdate.newLatLng(pos),
    );

    context.read<IPGeoModel>().isFetching = false;
  }
}
