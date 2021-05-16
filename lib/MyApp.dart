import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/qualities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'filterSheet.dart';
import 'park.dart';
import 'toilet.dart';

class MyApp extends StatefulWidget {
  Map<String, bool> filterMap = <String, bool>{
    "Bollspel": false,
    "Djurhållning": false,
    "Grillning": false,
    "Lekpark": false,
    "Parklek": false,
    "Plaskdamm": false,
  };

  @override
  _MyAppState createState() => _MyAppState();

  void updateFilterMap(Map<String, bool> map) {
    filterMap = map;
  }
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  GoogleMapController mapController;
  String mapStyling;
  ClusterManager clusterManager;

  // Coordinates for DSV, Kista.
  final CameraPosition dsv = CameraPosition(target: LatLng(59.40672485297707, 17.94522607914621), zoom: 10);

  Set<Marker> markers = Set();
  
  List<ClusterItem<Park>> parks;
  _initParks() {
    parks = [];

    getParks().then((loadedParks) {
      for (Park p in loadedParks) {
        parks.add(ClusterItem(LatLng(p.lat, p.long), item: p));
      }
    });
  }

  initState() {
    super.initState();

    rootBundle.loadString('map_style.txt').then((string) {
      mapStyling = string;
    });

    _initParks();
    clusterManager = _initClusterManager();
  }

  //Cluster implementation stolen from: https://pub.dev/packages/google_maps_cluster_manager
  ClusterManager _initClusterManager() {
    return ClusterManager<Park>(parks, _updateMarkers, initialZoom: dsv.zoom, stopClusteringZoom: 14.0, markerBuilder: markerBuilder); //Change stopClusteringZoom at your own risk
  }

  static Future<Marker> Function(Cluster) get markerBuilder => (cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      onTap: () {
        if (cluster.items.length == 1) {
          Park p = cluster.items.first as Park;
          print("This is ${p.name} and has the following qualities:");
          for (Qualities q in p.parkQualities) {
            print(q.toString());
          }
        }
      },
      icon: await getClusterBitmap(cluster.isMultiple ? 125 : 75, text: cluster.isMultiple ? cluster.count.toString() : null),
    );
  };

  static Future<BitmapDescriptor> getClusterBitmap(int size, {String text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.lightGreen;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
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

  void _showFilters() {
    showModalBottomSheet(context: context, builder: (context) => Filter());

    setState(() {
      // todo
      // Här ska filtret uppdateras..... På något sätt
    });
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
            drawer: buildDrawer(),
            body:
                TabBarView(physics: NeverScrollableScrollPhysics(), children: [
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
            floatingActionButton: buildFloatingActionButtonsColumn()));
  }

  Drawer buildDrawer() {
    return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  child: Text(
                    'Drawer',
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text("Logga in")
                )
              ],
            )
          );
  }

  Column buildFloatingActionButtonsColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () {
            print("Not implemented");
          },
          child: Icon(Icons.search),
        ),
        FloatingActionButton(
          onPressed: _showFilters,
          child: Icon(Icons.filter_alt_outlined),
        ),
        FloatingActionButton(
          onPressed: _currentLocation,
          child: Icon(Icons.location_on),
        ),
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
        mapType: MapType.normal,
        initialCameraPosition: dsv,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          controller.setMapStyle(mapStyling);
          clusterManager.setMapController(controller);
        },
        onCameraMove: clusterManager.onCameraMove,
        onCameraIdle: clusterManager.updateMap);
  }
}
