import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/qualities.dart';
import 'package:flutter_app/toilet.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'filterSheet.dart';
import 'park.dart';

Map<Qualities, bool> filterMap = <Qualities, bool>{
  Qualities.ballplay: false,
  Qualities.parkplay: false,
  Qualities.animal: false,
  Qualities.grill: false,
  Qualities.natureplay: false,
  Qualities.water_play: false,
  Qualities.playground: false,
  Qualities.out_bath: false,
};

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  void updateFilterMap(Map<Qualities, bool> map) {
    filterMap = map;
  }
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  GoogleMapController mapController;
  String mapStyling;
  ClusterManager clusterManager;
  var showToilets = false;

  // Coordinates for DSV, Kista.
  final CameraPosition dsv = CameraPosition(
      target: LatLng(59.40672485297707, 17.94522607914621), zoom: 10);

  Set<Marker> markers = Set();

  HashMap<String, ClusterItem<Park>> parks;

  _initParks() {
    print("init");
    parks = new HashMap();

    //All parks are loaded and stored in ClusterItems.
    getParks().then((loadedParks) {
      for (Park p in loadedParks) {
        parks.putIfAbsent(
            p.name, () => ClusterItem(LatLng(p.lat, p.long), item: p));
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
    return ClusterManager<Park>(parks.values, _updateMarkers,
        initialZoom: dsv.zoom,
        stopClusteringZoom: 14.0,
        markerBuilder:
            markerBuilder); //Change stopClusteringZoom at your own risk
  }

  buildParkInfo(Park p) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: [
        for (Qualities q in p.parkQualities)
          InputChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              child: Icon(Icons.accessibility),
            ),
            label: Text(q.formatted),
            labelStyle: TextStyle(
                color: map[Qualities.grill] ? Colors.white : Colors.black),
            selected: false,
            onSelected: (bool selected) {
              setState(() {
                map[Qualities.grill] = !map[Qualities.grill];
              });
            },
            selectedColor: Colors.indigo,
            checkmarkColor: Colors.black,
          )
      ],
    );
  }

  Future<Marker> Function(Cluster) get markerBuilder => (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            if (cluster.count == 1) {
              Park p = cluster.items.first as Park;
              showClickedParkSheet(p);
            }
          },
          //If to cluster consists of multiple parks it is bigger and gets the amount of parks as icon, needs to be defined as own function to notuse default values..
          icon: await getClusterBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  static Future<BitmapDescriptor> getClusterBitmap(int size,
      {String text}) async {
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

  List<ClusterItem<Park>> discardedParks =
      []; //Saves all the parks that have been discarded by the filter.
  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      //If no filters are selected, for every quality remove the pars that do not have it.
      if (!noneSelected()) {
        parks.removeWhere((key, value) => removePark(value));
      }

      //Adds the previously discarded parks that now conform to the filter.
      discardedParks.removeWhere((element) => reAddPark(element));

      //Updates the markers.
      this.markers = markers;
      if (showToilets) loadToilets();
    });
  }

  bool removePark(ClusterItem<Park> element) {
    for (Qualities q in filterMap.keys) {
      if (filterMap[q] && !element.item.parkQualities.contains(q)) {
        discardedParks
            .add(element); //To avoid concurrent modification exception.
        return true;
      }
    }
    return false;
  }

  bool reAddPark(ClusterItem<Park> element) {
    for (Qualities q in filterMap.keys) {
      if (filterMap[q] && !(element.item).parkQualities.contains(q)) {
        return false;
      }
    }
    parks.putIfAbsent(element.item.name, () => element);
    return true;
  }

  bool noneSelected() {
    return !filterMap.values.contains(true);
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
        //change what is shown as suggestions
        setState(() {
          setSuggestions(query);
        });
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
                children: getSuggestions()
                    .map((park) => GestureDetector(
                          onTap: () {
                            findAndGoToMarker(park);
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            String snackBarText = 'Kameran fokuserar nu på: ' +
                                park.item.name.toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(snackBarText),
                              ),
                            );
                          },
                          child: Container(
                            //height: 112,
                            width: 420,
                            child: Padding(
                              child: Text(park.item.name,
                                  style: TextStyle(fontSize: 30)),
                              padding: EdgeInsets.fromLTRB(50, 25, 50, 25),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                          ),
                        ))
                    .toList()),
          ),
        );
      },
    );
  }

  void _showFilters() {
    showModalBottomSheet(context: context, builder: (context) => Filter());
    this.reassemble();
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
        ListTile(leading: Icon(Icons.account_circle), title: Text("Logga in"))
      ],
    ));
  }

  Column buildFloatingActionButtonsColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        /*** THIS BUTTON IS PROBABLY NOT NEEDED. ***\
            FloatingActionButton(
            onPressed: () {
            print("Not implemented");
            },
            child: Icon(Icons.search),
            ),

         */
        FloatingActionButton(
          onPressed: _showFilters,
          child: Icon(Icons.filter_alt_outlined),
        ),
        FloatingActionButton(
          onPressed: _currentLocation,
          child: Icon(Icons.location_on),
        ),
        FloatingActionButton(
          onPressed: () => {showToilets = !showToilets},
          child: Icon(Icons.wc_rounded),
        )
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
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: dsv,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          controller.setMapStyle(mapStyling);
          clusterManager.setMapController(controller);
        },
        onCameraMove: clusterManager.onCameraMove,
        onCameraIdle: clusterManager.updateMap,
        cameraTargetBounds: new CameraTargetBounds(new LatLngBounds(
          northeast: LatLng(59.491684, 18.355865),
          southwest: LatLng(59.220681, 17.837629),
        )));
  }

  List<ClusterItem<Park>> parkSuggestions = [];

  List<ClusterItem<Park>> getSuggestions() {
    return parkSuggestions;
  }

  showClickedParkSheet(p) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 400,
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[Text(p.name), buildParkInfo(p)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () => print("Not implemented"),
                          child: Text("Favorit",
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.yellowAccent,
                              textStyle: TextStyle(color: Colors.black))),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Stäng",
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen))
                    ],
                  ),
                ],
              ));
        });
  }

  void setSuggestions(String query) {
    parkSuggestions = [];
    if (query.isEmpty) {
      return;
    }
    for (String name in parks.keys) {
      if (name.toLowerCase().startsWith(query.toLowerCase())) {
        parkSuggestions.add(parks[name]);
      }
    }
  }

  findAndGoToMarker(ClusterItem<Park> park) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(park.location.latitude, park.location.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void loadToilets() {
    if (showToilets == false) {
      getToilets().then((toilets) {
        for (Toilet t in toilets) {
          removeMarker(t.id.toString(), t.lat, t.long, "wc");
        }
      });
    } else {
      getToilets().then((toilets) {
        for (Toilet t in toilets) {
          addMarker(t.id.toString(), t.lat, t.long, "wc");
        }
      });
    }
  }

  addMarker(String id, double lat, double long, String type) {
    MarkerId markerId = MarkerId(id + type);
    final Marker marker =
        Marker(markerId: markerId, position: LatLng(lat, long));
    setState(() {
      markers.add(marker);
    });
  }

  void removeMarker(String id, double lat, double long, String type) {
    MarkerId markerId = MarkerId(id + type);
    final Marker marker =
        Marker(markerId: markerId, position: LatLng(lat, long));
    setState(() {
      markers.remove(marker);
    });
  }
}
