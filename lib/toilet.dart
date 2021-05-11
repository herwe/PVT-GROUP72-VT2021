import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location.dart';

class Toilet extends Location {
  bool operational;
  bool adapted;

  Toilet(int id, double lat, double long, bool operational, bool adapted) : super(id, lat, long) {
    this.operational = operational;
    this.adapted = adapted;
  }

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(json['id'], json['latitude'], json['longitude'], json['operational'], json['adapted']);
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