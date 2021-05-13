import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/MyApp.dart';

Map<String, bool> map = <String, bool>{
  "Bollspel": false,
  "Djurhållning": false,
  "Grillning": false,
  "Lekpark": false,
  "Parklek": false,
  "Plaskdamm": false,
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
                    color: map["Bollspel"] ? Colors.white : Colors.black),
                selected: map["Bollspel"],
                onSelected: (bool selected) {
                  setState(() {
                    map["Bollspel"] = !map["Bollspel"];
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
                    color: map["Djurhållning"] ? Colors.white : Colors.black),
                selected: map["Djurhållning"],
                onSelected: (bool selected) {
                  setState(() {
                    map["Djurhållning"] = !map["Djurhållning"];
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
                    color: map["Grillning"] ? Colors.white : Colors.black),
                selected: map["Grillning"],
                onSelected: (bool selected) {
                  setState(() {
                    map["Grillning"] = !map["Grillning"];
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
                  color: map["Lekpark"] ? Colors.white : Colors.black),
              selected: map["Lekpark"],
              onSelected: (bool selected) {
                setState(() {
                  map["Lekpark"] = !map["Lekpark"];
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
                  color: map["Parklek"] ? Colors.white : Colors.black),
              selected: map["Parklek"],
              onSelected: (bool selected) {
                setState(() {
                  map["Parklek"] = !map["Parklek"];
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
                  color: map["Plaskdamm"] ? Colors.white : Colors.black),
              selected: map["Plaskdamm"],
              onSelected: (bool selected) {
                setState(() {
                  map["Plaskdamm"] = !map["Plaskdamm"];
                });
              },
              selectedColor: Colors.indigo,
              checkmarkColor: Colors.black,
            ),
          ]),
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
