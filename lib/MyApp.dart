import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'toilet.dart';

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
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
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

  loadToilets() {
    getToilets().then((toilets) {
      for (Toilet t in toilets) {
        String info = "Dritsatt: ${t.operational}\nAnpasad: ${t.adapted}";
        addMarker(t.id.toString(), t.lat, t.long, "wc", info, toiletIcon);
      }
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
          print("marker tapped: $markerId");
        });

    setState(() {
      markers[markerId] = marker;
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
  Widget build(BuildContext context) => MaterialApp(home: buildViews()
    //mainAxisAlignment: MainAxisAlignment.spaceBetween
  );

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
                buildGoogleMap(),
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
          floatingActionButton: buildFloatingActionButtonsColumn()
        )
    );
  }

  Column buildFloatingActionButtonsColumn() {
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
        /**  FloatingActionButton(
            onPressed: goBack,
            child: Icon(Icons.home),
            ),**/
      ],
    );
  }

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
}