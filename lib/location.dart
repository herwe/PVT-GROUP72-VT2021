import 'package:flutter/cupertino.dart';

class Location {
  int id;
  double lat;
  double long;

  Location(int id, double lat, double long) {
    this.id = id;
    this.lat = lat;
    this.long = long;
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(json['id'], json['latitude'], json['longitude']);
  }
}