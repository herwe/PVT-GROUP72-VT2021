import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location.dart';

class Toilet extends Location {
  final bool operational;
  final bool adapted;

  Toilet({@required id, @required lat, @required long, @required this.operational, @required this.adapted}) : super.constructor(id, lat, long);

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
        id: json['id'],
        lat: json['latitude'],
        long: json['longitude'],
        operational: json['operational'],
        adapted: json['adapted']
    );
  }
}

Future<List<Toilet>> getToilets() async {
  try {
    var url = Uri.parse('http://78.72.246.146:8280/group2/wc/all');
    http.Response response = await http.get(url);
    final data = jsonDecode(response.body);

    List<Toilet> toilets = [];
    for (Map m in data) {
      toilets.add(Toilet.fromJson(m));
    }

    return toilets;
  }
  catch (e) {
    print("Error loading toilets");
    return [];
  }
}