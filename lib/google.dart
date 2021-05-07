import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'toilet.dart';

class GoogleState extends State<Google> {
  final int smallIconSize = 50;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _center = const LatLng(59.40672485297707, 17.94522607914621);
  GoogleMapController mapController;
  String mapStyling;

  Uint8List toiletIcon;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  loadIcons() async {
    toiletIcon = await getBytesFromAsset('assets/wc.png', smallIconSize);
  }

  initState() {
    super.initState();
    rootBundle.loadString('map_style.txt').then((string) {
      mapStyling = string;
    });
    loadIcons();
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      mapToolbarEnabled: false,
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers.values),
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mounted)
      setState(() {
        mapController = controller;
        controller.setMapStyle(mapStyling);
      });
  }

  addMarker(String id, double lat, double long, String type, String info,
      Uint8List icon) {
    MarkerId markerId = MarkerId(id + type);

    final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(icon),
        markerId: markerId,
        position: LatLng(lat, long),
        onTap: () {
          print("marker tapped: ${markerId}");
        });

    setState(() {
      markers[markerId] = marker;
    });
  }

  loadToilets() {
    getToilets().then((toilets) {
      for (Toilet t in toilets) {
        String info = "Dritsatt: ${t.operational}\nAnpasad: ${t.adapted}";
        addMarker(t.id.toString(), t.lat, t.long, "wc", info, toiletIcon);
      }
    });
  }

  void currentLocation() async {
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return buildGoogleMap();
  }
}

class Google extends StatefulWidget {
  @override
  GoogleState createState() => GoogleState();
}
