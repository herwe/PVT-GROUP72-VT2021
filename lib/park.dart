import 'package:flutter_app/location.dart';
import 'qualities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Park extends Location {
  String name;
  List<Qualities> parkQualities = [];
  double distance;

  Park(int id, double lat, double long, String name) : super(id, lat, long) {
    this.name = name;
  }

  factory Park.fromJson(Map<String, dynamic> json) {
    Park park =  Park(json['id'], json['latitude'], json['longitude'], json['name']);

    park.fillQualities(json);

    return park;
  }

  void fillQualities(Map<String, dynamic> json) {
    //This map should really not be necessary, the formatted version in the enum should be enough however this is how they are referred to as in the database and therefore how they are loaded.
    var map = {
      'green': Qualities.green,
      'playground': Qualities.playground,
      'natureplay': Qualities.natureplay,
      'calm': Qualities.calm,
      'ballplay': Qualities.ballplay,
      'parkplay' : Qualities.parkplay,
      'picknick': Qualities.picknick,
      'grill' : Qualities.grill,
      'sleigh': Qualities.sleigh,
      'view': Qualities.view,
      'forrest': Qualities.forest,
      'animal': Qualities.animal,
      'water': Qualities.water,
      'out_bath': Qualities.out_bath,
      'nature_expr': Qualities.nature_expr,
      'out_serve': Qualities.out_serve,
      'water_play': Qualities.water_play,
      'bath_f': Qualities.bath_f
    };

    for (String s in json.keys) {
      if (map.containsKey(s) && json[s]) {
        parkQualities.add(map[s]);
      }
    }
  }
}

Future<List<Park>> getParks() async {
  try {
    var url = Uri.parse('http://78.72.246.146:8280/group2/parks/all');
    http.Response response = await http.get(url);
    final data = json.decode(utf8.decode(response.bodyBytes));

    List<Park> parks = [];
    for (Map m in data) {
      parks.add(Park.fromJson(m));
    }

    return parks;
  }
  catch (e) {
    print("Error loading parks: " + e);
    print(e);
    return [];
  }
}