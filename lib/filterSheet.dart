import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'park.dart';
import 'toilet.dart';

class Wood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WoodState();
}

class WoodState extends State<Wood> {
  bool _useChisel = false;
  var _parklek = false;
  List<String> filterStrings = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('Bollspel'),
                labelStyle:
                TextStyle(color: _parklek ? Colors.black : Colors.white),
                selected: _parklek,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      filterStrings.add('Bollspel');
                    } else {
                      filterStrings.remove('Bollspel');
                    }
                    _parklek = !_parklek;
                  });
                },
                selectedColor: Colors.indigo,
                checkmarkColor: Colors.black,
              ),
              InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(Icons.accessibility),
                  ),
                  label: Text('Djurhållning'),
                  onPressed: () {
                    print('I am the one thing in life.');
                  }),
              InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(Icons.accessibility),
                  ),
                  label: Text('Grillning'),
                  onPressed: () {
                    print('I am the one thing in life.');
                  }),
            ],
          ),
          Row(children: [
            InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('Lekpark'),
                onPressed: () {
                  print('I am the one thing in life.');
                }),
            InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('Parklek'),
                onPressed: () {
                  print('I am the one thing in life.');
                }),
            InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('Plaskdamm'),
                onPressed: () {
                  print('I am the one thing in life.');
                }),
          ]),
          /*
          Row(
            children: [
              InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(Icons.accessibility),
                  ),
                  label: Text('Utomhusbad'),
                  onPressed: () {
                    print('I am the one thing in life.');
                  }),
              InputChip(
                  label: Text('Use Chisel'),
                  selectedColor: Colors.amber,
                  checkmarkColor: Colors.black,
                  selected: _useChisel,
                  onSelected: (bool newValue) {
                    setState(() {
                      _useChisel = !_useChisel;
                      print(_useChisel);
                    });
                  }),
            ],
          ),

               */
          Container(
            child: InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.teal.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('OK'),
                onPressed: () {
                  print('I am the one thing in life.');
                }),
          )
        ],
      ),
      color: Colors.transparent,
    );
  }
}