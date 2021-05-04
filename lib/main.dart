import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  String mapStyling;


  // Coordinates for DSV, Kista.
  final LatLng _center = const LatLng(59.40672485297707, 17.94522607914621);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  initState() {
    super.initState();
    rootBundle.loadString('map_style.txt').then((string) {
      mapStyling = string;
    });
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

  Future<List<Toilet>> getToilets() async {
    try {
      var url = Uri.parse('http://78.72.246.146:8280/group2/wc/all');
      http.Response response = await http.get(url);
      final data = jsonDecode(response.body);

      List<Toilet> toilets = [];
      for (Map i in data) {
        toilets.add(Toilet.fromJson(i));
      }

      return toilets;
    }
    catch (e) {
      print("Error loading toilets");
      return [];
    }
  }

  loadToilets() {
    getToilets().then((toilets) {
      for (Toilet t in toilets) {
        addMarker(t.id.toString(), t.lat, t.long, "wc");
      }
    });
  }

  addMarker(String id, double lat, double long, String type) {
    MarkerId markerId = MarkerId(id + type);

    final Marker marker = Marker (
      markerId: markerId,
      position: LatLng(lat, long)
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
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
            zoom: 15.0,
          ),
        ),
          floatingActionButton: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                  onPressed: _currentLocation, child: Icon(Icons.search),),
              FloatingActionButton(
                  onPressed: _currentLocation, child: Icon(Icons.filter_alt_outlined),),
              FloatingActionButton(
                onPressed: _currentLocation, child: Icon(Icons.location_on),),
              FloatingActionButton(
                onPressed: loadToilets, child: Icon(Icons.airline_seat_legroom_extra),),
            ],
          )
      ),
    );
  }
}

class Toilet {
  final int id;
  final double lat;
  final double long;
  final bool operational;
  final bool adapted;

  Toilet({@required this.id, @required this.lat, @required this.long, @required this.operational, @required this.adapted});

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
      id: json['id'],
      lat: json['latitude'],
      long: json['longitude'],
      operational: json['operational'],
      adapted: json['adapted']
    );
  }
}