// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/AppWrapper.dart';
import 'package:flutter_app/MyApp.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test if a frame is triggered', (WidgetTester tester) async {
    await tester.pumpWidget(AppWrapper());

    expect(true, true);
  });

  testWidgets('Test if JSON for map styling is properly loaded', (WidgetTester tester) async {
    await tester.pumpWidget(AppWrapper());
    Future<String> mapStyling = read();
    String s = "";
    mapStyling.then((value) {
      s = value;
    });

    final expectedString = find.text(s);

    expect(expectedString, findsOneWidget);

  });

  testWidgets('Since to HTTP connection is established, show error while loading park', (WidgetTester tester) async {
    await tester.pumpWidget(AppWrapper());

    final titleFinder = find.text('Error loading parks');

    expect(titleFinder, findsOneWidget);
  });


}

Future<String> read() async {
  String text;
  try {
    final File file = File('map_style');
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}
