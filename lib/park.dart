import 'package:flutter_app/location.dart';
import 'qualities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Park extends Location {
  String name;
  List<Qualities> parkQualities = [];

  //Park({@required id, @required lat, @required long, @required this.name}) : super.constructor(id, lat, long);

  Park(int id, double lat, double long, String name) : super(id, lat, long) {
    this.name = name;
  }

  factory Park.fromJson(Map<String, dynamic> json) {
    Park park =  Park(json['id'], json['latitude'], json['longitude'], json['name']);

    park.fillQualities(json);

    return park;
  }

  void fillQualities(Map<String, dynamic> json) {
    if (json['green']) {
      parkQualities.add(Qualities.green);
    }

    if (json['playground']) {
      parkQualities.add(Qualities.playground);
    }

    if (json['natureplay']) {
      parkQualities.add(Qualities.natureplay);
    }

    if (json['calm']) {
      parkQualities.add(Qualities.calm);
    }

    if (json['ballplay']) {
      parkQualities.add(Qualities.ballplay);
    }

    if (json['parkplay']) {
      parkQualities.add(Qualities.parkplay);
    }

    if (json['picknick']) {
      parkQualities.add(Qualities.picknick);
    }

    if (json['grill']) {
      parkQualities.add(Qualities.grill);
    }

    if (json['sleigh']) {
      parkQualities.add(Qualities.sleigh);
    }

    if (json['view']) {
      parkQualities.add(Qualities.view);
    }

    if (json['forrest']) {
      parkQualities.add(Qualities.forrest);
    }

    if (json['animal']) {
      parkQualities.add(Qualities.animal);
    }

    if (json['water']) {
      parkQualities.add(Qualities.water);
    }

    if (json['out_bath']) {
      parkQualities.add(Qualities.out_bath);
    }

    if (json['nature_expr']) {
      parkQualities.add(Qualities.nature_expr);
    }

    if (json['out_serve']) {
      parkQualities.add(Qualities.out_serve);
    }

    if (json['water_play']) {
      parkQualities.add(Qualities.water_play);
    }

    if (json['bath_f']) {
      parkQualities.add(Qualities.bath_f);
    }
  }
}

Future<List<Park>> getParks() async {
  try {
    var url = Uri.parse('http://78.72.246.146:8280/group2/parks/all');
    http.Response response = await http.get(url);
    final data = jsonDecode(response.body);

    List<Park> parks = [];
    for (Map m in data) {
      parks.add(Park.fromJson(m));
    }

    return parks;
  }
  catch (e) {
    print("Error loading parks");
    return [];
  }
}