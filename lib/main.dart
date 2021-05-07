import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/google.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

void main() => runApp(AppWrapper());
TabController _tabController;

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
  Widget build(BuildContext context) => MaterialApp(home: buildScaffold()
      //mainAxisAlignment: MainAxisAlignment.spaceBetween
      );
  GoogleState _google = new GoogleState();
  Scaffold buildScaffold() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _google.buildGoogleMap(),
            buildFloatingSearchBar(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: buildColumn());
  }

  AppBar buildAppBar() {
    return AppBar(
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
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _google.currentLocation,
          child: Icon(Icons.search),
        ),
        FloatingActionButton(
          onPressed: _google.currentLocation,
          child: Icon(Icons.filter_alt_outlined),
        ),
        FloatingActionButton(
          onPressed: _google.currentLocation,
          child: Icon(Icons.location_on),
        ),
        FloatingActionButton(
          onPressed: _google.loadToilets,
          child: Icon(Icons.wc_rounded),
        ),
        /**  FloatingActionButton(
            onPressed: goBack,
            child: Icon(Icons.home),
            ),**/
      ],
    );
  }
}
