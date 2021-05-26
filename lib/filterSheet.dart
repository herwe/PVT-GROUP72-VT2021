import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/MyApp.dart';
import 'package:flutter_app/qualities.dart';

//more qualities could be added when necessary
Map<Qualities, bool> map = <Qualities, bool>{
  Qualities.ballplay: false,
  Qualities.parkplay: false,
  Qualities.animal: false,
  Qualities.grill: false,
  Qualities.natureplay: false,
  Qualities.water_play: false,
  Qualities.playground: false,
  Qualities.out_bath: false,
};

class Filter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterState();
  }
}

class FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //this could be replaced with a wrap and a list of qualities  if we augment the file qualities.dart with icons for each quality
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
                labelStyle: TextStyle(
                    color:
                        map[Qualities.ballplay] ? Colors.white : Colors.black),
                selected: map[Qualities.ballplay],
                onSelected: (bool selected) {
                  setState(() {
                    map[Qualities.ballplay] = !map[Qualities.ballplay];
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
                labelStyle: TextStyle(
                    color: map[Qualities.animal] ? Colors.white : Colors.black),
                selected: map[Qualities.animal],
                onSelected: (bool selected) {
                  setState(() {
                    map[Qualities.animal] = !map[Qualities.animal];
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
                label: Text('Grillning'),
                labelStyle: TextStyle(
                    color: map[Qualities.grill] ? Colors.white : Colors.black),
                selected: map[Qualities.grill],
                onSelected: (bool selected) {
                  setState(() {
                    map[Qualities.grill] = !map[Qualities.grill];
                  });
                },
                selectedColor: Colors.indigo,
                checkmarkColor: Colors.black,
              ),
            ],
          ),
          Row(children: [
            InputChip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: Icon(Icons.accessibility),
              ),
              label: Text('Lekpark'),
              labelStyle: TextStyle(
                  color:
                      map[Qualities.playground] ? Colors.white : Colors.black),
              selected: map[Qualities.playground],
              onSelected: (bool selected) {
                setState(() {
                  map[Qualities.playground] = !map[Qualities.playground];
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
              label: Text('Parklek'),
              labelStyle: TextStyle(
                  color: map[Qualities.parkplay] ? Colors.white : Colors.black),
              selected: map[Qualities.parkplay],
              onSelected: (bool selected) {
                setState(() {
                  map[Qualities.parkplay] = !map[Qualities.parkplay];
                  map[Qualities.natureplay] = !map[Qualities.natureplay];
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
              label: Text('Plaskdamm'),
              labelStyle: TextStyle(
                  color:
                      map[Qualities.water_play] ? Colors.white : Colors.black),
              selected: map[Qualities.water_play],
              onSelected: (bool selected) {
                setState(() {
                  map[Qualities.water_play] = !map[Qualities.water_play];
                });
              },
              selectedColor: Colors.indigo,
              checkmarkColor: Colors.black,
            ),
          ]),
          Row(
            children: [
              InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('Utomhusbad'),
                labelStyle: TextStyle(
                    color:
                        map[Qualities.out_bath] ? Colors.white : Colors.black),
                selected: map[Qualities.out_bath],
                onSelected: (bool selected) {
                  setState(() {
                    map[Qualities.out_bath] = !map[Qualities.out_bath];
                  });
                },
                selectedColor: Colors.indigo,
                checkmarkColor: Colors.black,
              ),
            ],
          ),
          Container(
            child: InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.teal.shade800,
                  child: Icon(Icons.accessibility),
                ),
                label: Text('OK'),
                onPressed: () {
                  MyApp().updateFilterMap(map);
                }),
          )
        ],
      ),
      color: Colors.transparent,
    );
  }
}
