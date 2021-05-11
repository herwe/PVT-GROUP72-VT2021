import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

import 'toilet.dart';
import 'park.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  //GoogleMapController mapController;
  Completer<GoogleMapController> mapController = Completer();
  String mapStyling;
  ClusterManager clusterManager;

  // Coordinates for DSV, Kista.
  final CameraPosition dsv = CameraPosition(target: LatLng(59.40672485297707, 17.94522607914621), zoom: 10);
  final int smallIconSize = 50;

  Set<Marker> markers = Set();
  
  List<ClusterItem<Park>> parks;

  List<ClusterItem<Park>> _initParks() {
    List<ClusterItem<Park>> parks = [];

    getParks().then((loadedParks) {
      for (Park p in loadedParks) {
        parks.add(ClusterItem(LatLng(p.lat, p.long), item: Park(p.id, p.lat, p.long, p.name)));
      }
    });

    return parks;
  }

  _initToilets() {
    getToilets().then((loadedToilets) {
      for (Toilet t in loadedToilets) {
        markers.add(Marker(
          icon: toiletIcon,
          markerId: MarkerId(t.id.toString() + "wc"),
          position: LatLng(t.lat, t.long),
          onTap: () {
            print("Is toilets");
          }
        ));
      }
    });
  }

  BitmapDescriptor toiletIcon;

  initState() {
    super.initState();

    rootBundle.loadString('map_style.txt').then((string) {
      mapStyling = string;
    });
    loadIcons();
    parks = _initParks();
    _initToilets();
    clusterManager = _initClusterManager();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Park>(parks, _updateMarkers, initialZoom: dsv.zoom, stopClusteringZoom: 15.0, extraPercent: 0.2); //Change stopClusteringZoom at your own risk
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  loadIcons() async {
    toiletIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset('assets/wc.png', smallIconSize));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  /*void _onMapCreated(GoogleMapController controller) {
    if (mounted)
      setState(() {
        mapController = controller;
        controller.setMapStyle(mapStyling);
      });
  }*/

  /*void _currentLocation() async {
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
  }*/

  loadToilets() {
    getToilets().then((toilets) {
      for (Toilet t in toilets) {
        String info = "Dritsatt: ${t.operational}\nAnpasad: ${t.adapted}";
        addMarker(t.id.toString(), t.lat, t.long, "wc", info, toiletIcon);
      }
    });
  }

  loadParks() {
    getParks().then((parks) {
      for (Park p in parks) {
        addMarkerDefault(p.id.toString(), p.lat, p.long, "park", "info");
      }
    });
  }

  addMarker(String id, double lat, double long, String type, String info, BitmapDescriptor icon) {
    MarkerId markerId = MarkerId(id + type);

    final Marker marker = Marker(
        icon: icon,
        markerId: markerId,
        position: LatLng(lat, long),
        onTap: () {
          print("marker tapped: $markerId");
        });

    setState(() {
      markers.add(marker);
    });
  }

  addMarkerDefault(String id, double lat, double long, String type, String info) {
    MarkerId markerId = MarkerId(id + type);

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        onTap: () {
          print("marker tapped: $markerId");
        });

    setState(() {
      markers.add(marker);
    });
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),

        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: dsv,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            mapController.complete(controller);
            controller.setMapStyle(mapStyling);
            clusterManager.setMapController(controller);
          },
          onCameraMove: clusterManager.onCameraMove,
          onCameraIdle: clusterManager.updateMap),
    );
  }

  DefaultTabController buildViews() {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: buildAppBar(),
          body: TabBarView(children: [
            Stack(
              fit: StackFit.expand,
              children: [
                //buildGoogleMap(),
                buildFloatingSearchBar(),
              ],
            ),
            Stack(
              fit: StackFit.expand,
              children: [
                buildFloatingSearchBar(),
              ],
            )
          ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          //floatingActionButton: buildFloatingActionButtonsColumn()
        )
    );
  }

  /*Column buildFloatingActionButtonsColumn() {
    return Column(
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
            onPressed: loadParks,
            child: Icon(Icons.park),
            ),
      ],
    );
  }*/

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 48,
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.map),
          ),
          Tab(
            icon: Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
    );
  }

  /*GoogleMap buildGoogleMap() {
    return GoogleMap(
      mapToolbarEnabled: false,
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers),
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: dsv,
    );
  }*/
}