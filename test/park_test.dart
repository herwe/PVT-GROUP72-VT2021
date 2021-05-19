import 'package:flutter/material.dart';
import 'package:flutter_app/MyApp.dart';
import 'package:flutter_app/qualities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('See if the marker returns Pålsundsparken as a string', () {
    var result = CheckPalsundsparkenMarkerName.validate("Pålsundsparken");
    expect(result, "Pålsundsparken");
  });

  test('Should return null if marker Pålsundsparken has another name', () {
    var result = CheckPalsundsparkenMarkerName.validate("BlaBlaBla");
    expect(result, null);
  });

  test('Check if Pålsundsparken has the correct longitude', () {
    var result = CheckPalsundsparkenMarkerCoordinateLong.validate(18.041730036953794);
    expect(result, 18.041730036953794);
  });

  test('Should return 0 if marker Pålsundsparken has another longitude', () {
    final double RANDOM_DOUBLE = 324.443432345;
    var result = CheckPalsundsparkenMarkerCoordinateLong.validate(RANDOM_DOUBLE);
    expect(result, 0);
  });

  test('Check if Pålsundsparken populates a list with the correct Qualities', () {
    final List PALSUNDSPARKEN_QUALITIES = [Qualities.green, Qualities.parkplay, Qualities.view, Qualities.water];
    var result = CheckPalsundsparkenQualities.validate(PALSUNDSPARKEN_QUALITIES);
    expect(result, PALSUNDSPARKEN_QUALITIES);
  });

  test('Return null if Pålsundsparken is missing one of its expected qualities', () {
    final List PALSUNDSPARKEN_QUALITIES_MISSING_ONE_QUALITY = [Qualities.green, Qualities.parkplay, Qualities.view];
    var result = CheckPalsundsparkenQualities.validate(PALSUNDSPARKEN_QUALITIES_MISSING_ONE_QUALITY);
    expect(result, null);
  });

  test('Return null if Pålsundsparken is having more qualities than expected', () {
    final List PALSUNDSPARKEN_QUALITIES_WITH_WRONG_QUALITIES = [Qualities.green, Qualities.parkplay, Qualities.view, Qualities.view, Qualities.animal, Qualities.out_bath];
    var result = CheckPalsundsparkenQualities.validate(PALSUNDSPARKEN_QUALITIES_WITH_WRONG_QUALITIES);
    expect(result, null);
  });
}