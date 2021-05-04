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

  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: MarkerId("marker_1"),
          position: LatLng(59.32747669589347, 18.05404397844236),
          infoWindow: InfoWindow(title: 'Stadshuset'),
      ),
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(59.330850807923106, 18.043734649777168),
        infoWindow: InfoWindow(title: 'Stockholms tingsrätt')
      ),
    };
  }

  Future<List<Bin>> getBins() async {
    try {
      var url = Uri.parse('http://78.72.246.146:8280/group2/bins/all');
      http.Response response = await http.get(url);
      final data = jsonDecode(response.body);
      List<Bin> bins = [];
      for (Map i in data) {
        bins.add(Bin.fromJson(i));
      }
      print(bins.length);
      return bins;
    }
    catch (e) {
      print("Error loading bins");
      return [];
    }
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
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          markers: _createMarker(),
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
        ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: _currentLocation, label: Text(""), icon: Icon(Icons.location_on),),
            ],
          )
      ),
    );
  }
}

class Bin {
  final double lat;
  final double long;

  Bin({@required this.lat, @required this.long});

  factory Bin.fromJson(Map<String, dynamic> json) {
    return Bin(
      lat: json['latitude'],
      long: json['longitude']
    );
  }
}