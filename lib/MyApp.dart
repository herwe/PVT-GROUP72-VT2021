import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'dart:typed_data';
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

  List<ClusterItem<Park>> parks; //Where all parks will be stored and sorted according to the current sorting setting in the list view tab (default alphabetically)

  List<Park> favoriteParks = [];

  Set<Marker> toiletMarkers = Set();

  BitmapDescriptor myIcon;

  var smallIconSize = 50;

  _initParks() {
    parks = [];

    //All parks are loaded and stored in ClusterItems.
    getParks().then((loadedParks) {
      for (Park p in loadedParks) {
        parks.add(ClusterItem(LatLng(p.lat, p.long), item: p));
      }

      sortParksAlphabetically();
    });
  }

  sortParksAlphabetically() {
    parks.sort((a, b) => a.item.name.compareTo(b.item.name));
  }

  sortParksReverseAlphabetically() {
    parks.sort((a, b) => -a.item.name.compareTo(b.item.name));
  }

  sortParksByDistance() {
    setParkDistances();
    parks.sort((a, b) => a.item.distance.compareTo(b.item.distance));
  }

  initState() {
    super.initState();

    rootBundle.loadString('map_style.txt').then((string) {
      mapStyling = string;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/wc.png')
        .then((onValue) {
      myIcon = onValue;
    });
    _initParks();
    clusterManager = _initClusterManager();
    _initToilets();

    setCurrentLocation();
    setParkDistances();
  }

  //Cluster implementation "stolen" from: https://pub.dev/packages/google_maps_cluster_manager
  ClusterManager _initClusterManager() {
    return ClusterManager<Park>(parks, _updateMarkers,
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
            labelStyle: TextStyle(color: Colors.black),
            selected: true,
            onSelected: (bool selected) {
              setState(() {});
            },
            selectedColor: Colors.white,
            showCheckmark: false,
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
    print("Only Favorites?: " + onlyFavorites.toString());
    print("Amount of Favorites: " + favoriteParks.length.toString());
    setState(() {
      //If no filters are selected, for every quality remove the parks that do not have it.
      parks.removeWhere((value) => removePark(value));

      //Adds the previously discarded parks that now conform to the filter.
      discardedParks.removeWhere((element) => reAddPark(element));

      sortParksAlphabetically();

      //Updates the markers.
      this.markers = markers;
      if (showToilets) addToilets();
    });
  }

  bool removePark(ClusterItem<Park> element) {
    if (onlyFavorites && !favoriteParks.contains(element.item)) {
      discardedParks.add(element);
      return true;
    }

    if (!noneSelected()) {
      for (Qualities q in filterMap.keys) {
        if (filterMap[q] && !element.item.parkQualities.contains(q)) {
          discardedParks
              .add(element); //To avoid concurrent modification exception.
          return true;
        }
      }
    }

    return false;
  }

  bool reAddPark(ClusterItem<Park> element) {
    if (onlyFavorites && !favoriteParks.contains(element.item)) {
      return false;
    }

    for (Qualities q in filterMap.keys) {
      if (filterMap[q] && !(element.item).parkQualities.contains(q)) {
        return false;
      }
    }

    parks.add(element);
    return true;
  }

  bool noneSelected() {
    return !filterMap.values.contains(true);
  }

  LocationData currentLocation;
  void setCurrentLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
  }

  void _currentLocation() async {
    setCurrentLocation();

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
      builder: createSuggestionBlockHolder,
    );
  }

  Widget createSuggestionBlockHolder(context, transition) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: createSuggestionBlocks(context).toList()),
      ),
    );
  }

  Iterable<GestureDetector> createSuggestionBlocks(context) {
    return getSuggestions().map((park) => GestureDetector(
          onTap: () {
            findAndGoToMarker(park);
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            String snackBarText =
                'Kameran fokuserar nu på: ' + park.item.name.toString();
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
              child: Text(park.item.name, style: TextStyle(fontSize: 30)),
              padding: EdgeInsets.fromLTRB(50, 25, 50, 25),
            ),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
        ));
  }

  void _showFilters() {
    showModalBottomSheet(context: context, builder: (context) => Filter());
    this.reassemble();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(home: buildViews());

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
                  Column(
                    children: [
                      buildListViewTop(),
                      buildListView(),
                      buildListViewBottom()
                    ],
                  )
                ],
              )
            ]),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: buildFloatingActionButtonsColumn()));
  }

  String dropDownValue = "A - Ö";
  buildListViewTop() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text("Alla parker och deras kvaliteter",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [buildQualitySortingDropdownButton()],
          )
        ],
      ),
    );
  }

  DropdownButton<String> buildQualitySortingDropdownButton() {
    return DropdownButton<String>(
      items: <String>["A - Ö", "Ö - A", "Nära mig"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: dropDownValue,
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;

          if (dropDownValue == "A - Ö") {
            sortParksAlphabetically();
          } else if (dropDownValue == "Ö - A") {
            sortParksReverseAlphabetically();
          } else {
            sortParksByDistance();
          }
        });
      },
    );
  }

  buildListView() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return Container(
          child: Expanded(
            child: buildParksListView(),
          ),
        );
      },
    );
  }

  ListView buildParksListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: parks.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Column(
              children: [buildParkRow(index), buildParkInfo(parks[index].item)],
            ));
      },
    );
  }

  Row buildParkRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(parks[index].item.name),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (!favoriteParks.contains(parks[index].item)) {
                      favoriteParks.add(parks[index].item);
                    } else {
                      favoriteParks.remove(parks[index].item);
                    }
                  });
                },
                icon: favoriteParks.contains(parks[index].item)
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border, color: Colors.red)),
            dropDownValue == "Nära mig"
                ? Text("Avstånd: " +
                    parks[index].item.distance.toStringAsFixed(1) +
                    " km")
                : Text("") //When the drop drown is set tp "Nära mig" (Close to me) the distance will be shown as per the calculateCoordinateDistance method below.
          ],
        )
      ],
    );
  }

  //https://stackoverflow.com/questions/54138750/total-distance-calculation-from-latlng-list
  //Calculates the distance in km between the current location of the phone and the destination (the current park in question)
  double calculateCoordinateDistance(LatLng destination) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((destination.latitude - currentLocation.latitude) * p) / 2 +
        c(currentLocation.latitude * p) *
            c(destination.latitude * p) *
            (1 - c((destination.longitude - currentLocation.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  setParkDistances() {
    for (ClusterItem<Park> ci in parks) {
      ci.item.distance = calculateCoordinateDistance(ci.location);
    }
  }

  bool onlyFavorites = false;
  buildListViewBottom() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Visa Endast favoriter: ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Checkbox(
            value: onlyFavorites,
            onChanged: (value) {
              setState(() {
                onlyFavorites = !onlyFavorites;
                _updateMarkers(markers);
              });
            },
          )
        ],
      ),
    );
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
        FloatingActionButton(
          onPressed: _showFilters,
          child: Icon(Icons.filter_alt_outlined),
        ),
        FloatingActionButton(
          onPressed: _currentLocation,
          child: Icon(Icons.location_on),
        ),
        FloatingActionButton(
          onPressed: () =>
              {showToilets = !showToilets, _updateMarkers(markers)},
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
            icon: Icon(Icons.list),
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
                    children: [Text(p.name), buildParkInfo(p)],
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
    for (ClusterItem ci in parks) {
      if (ci.item.name.toLowerCase().startsWith(query.toLowerCase())) {
        print(ci.item.name);
        parkSuggestions.add(ci);
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
      removeToilets();
    } else {
      addToilets();
    }
  }

  void addToilets() {
    markers.addAll(toiletMarkers);
  }

  void removeToilets() {
    markers.removeAll(toiletMarkers);
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

  void _initToilets() {
    getToilets().then((toilets) {
      for (Toilet t in toilets) {
        String info = "Driftsatt: ${t.operational}\nAnpassad: ${t.adapted}";
        addToiletMarker(t.id.toString(), t.lat, t.long, "wc", info, toiletIcon);
      }
    });
  }

  void addToiletMarker(String id, double lat, double long, String type,
      String info, Uint8List icon) {
    MarkerId markerId = MarkerId(id + type);
    final Marker marker =
        Marker(markerId: markerId, position: LatLng(lat, long), icon: myIcon);

    setState(() {
      toiletMarkers.add(marker);
    });
  }

  Uint8List toiletIcon;
}
