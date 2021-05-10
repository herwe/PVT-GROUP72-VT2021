import 'package:flutter/cupertino.dart';

class Location {
  final int id;
  final double lat;
  final double long;

  Location.constructor(this.id, this.lat, this.long);
  Location({@required this.id, @required this.lat, @required this.long});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'],
        lat: json['latitude'],
        long: json['longitude']
    );
  }
}