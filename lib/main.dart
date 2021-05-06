import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'toilet.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());
TabController _tabController;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  GoogleMapController mapController;
  String mapStyling;

  // Coordinates for DSV, Kista.
  final LatLng _center = const LatLng(59.40672485297707, 17.94522607914621);
  final int smallIconSize = 50;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Uint8List toiletIcon;

  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    rootBundle.loadString('map_style.txt').then((string) {
      mapStyling = string;
    });
    loadIcons();
  }

  loadIcons() async {
    toiletIcon = await getBytesFromAsset('assets/wc.png', smallIconSize);
  }
  
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mounted)
      setState(() {
        mapController = controller;
        controller.setMapStyle(mapStyling);
      });
  }

  void _currentLocation() async {
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

  bool toiletsToggled = false;
  loadToilets() {
    if (!toiletsToggled) {
      getToilets().then((toilets) {
        for (Toilet t in toilets) {
          String info = "Dritsatt: ${t.operational}\nAnpasad: ${t.adapted}";
          addMarker(t.id.toString(), t.lat, t.long, "wc", info, toiletIcon);
        }
      });
      toiletsToggled = true;
    }
    else {
      setState(() {
        markers.removeWhere((key, value) => key.toString().contains("wc"));
        toiletsToggled = false;
      });
    }
  }

  addMarker(String id, double lat, double long, String type, String info, Uint8List icon) {
    MarkerId markerId = MarkerId(id + type);

    final Marker marker = Marker (
        icon: BitmapDescriptor.fromBytes(icon),
        markerId: markerId,
        position: LatLng(lat, long),
        onTap: () {
          print("marker tapped: ${markerId}");
        }
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  goBack() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: _center,
        zoom: 10,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              toolbarHeight: 48,
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.map),
                  ),
                  Tab(
                    icon: Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
            ),
            body: GoogleMap(
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
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _currentLocation,
                  child: Icon(Icons.search),
                ),
                FloatingActionButton(
                  onPressed: _currentLocation,
                  child: Icon(Icons.filter_alt_outlined),
                ),
                FloatingActionButton(
                  onPressed: _currentLocation,
                  child: Icon(Icons.location_on),
                ),
                FloatingActionButton(
                  onPressed: loadToilets,
                  child: Icon(Icons.airline_seat_legroom_extra),
                ),
                FloatingActionButton(
                  onPressed: goBack,
                  child: Icon(Icons.home),
                ),
              ],
            ))
        //mainAxisAlignment: MainAxisAlignment.spaceBetween
     );
  }
}