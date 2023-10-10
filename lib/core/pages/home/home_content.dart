import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    Key? key,
    required this.userPosition,
    this.map,
  }) : super(key: key);

  final LatLng userPosition;
  final Map<String, Object>? map;

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  final Completer<GoogleMapController> _controller = Completer();
  Polyline polyline = const Polyline(
    points: [],
    polylineId: PolylineId('parcours'),
    width: 5,
    color: Color.fromARGB(255, 252, 179, 0),
  );
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    var map = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.userPosition,
        zoom: 14.4746,
      ),
      mapType: MapType.normal,
      myLocationEnabled: true,
      compassEnabled: true,
      polylines: {polyline},
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
    return map;
  }

  @override
  void initState() {
    super.initState();
    if (widget.map.isNotNull) {
      final lines = widget.map!['LongLat'] as List;
      final building = widget.map!['Buildings'] as List;
      for (var element in lines) {
        final value = Map.from(element);
        polyline = polyline.copyWith(
          pointsParam: [
            ...polyline.points,
            LatLng(
              value['latitude'] != null
                  ? double.parse(value['latitude'].toString())
                  : 0,
              value['longitude'] != null
                  ? double.parse(value['longitude'].toString())
                  : 0,
            ),
          ],
        );
      }
      for (var element in building) {
        final value = Map.from(element);
        markers.add(Marker(
          markerId: const MarkerId('ui'),
          position: LatLng(
            value['latitude'] != null
                ? double.parse(value['latitude'].toString())
                : 0,
            value['longitude'] != null
                ? double.parse(value['longitude'].toString())
                : 0,
          ),
        ));
      }
    }
  }
}
