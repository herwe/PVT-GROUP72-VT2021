import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Toilet {
  final int id;
  final double lat;
  final double long;
  final bool operational;
  final bool adapted;

  Toilet({@required this.id, @required this.lat, @required this.long, @required this.operational, @required this.adapted});

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