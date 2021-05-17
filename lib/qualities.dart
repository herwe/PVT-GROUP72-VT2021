import 'package:flutter/cupertino.dart';

class ExtendsQualitiesEnum {
  ExtendsQualitiesEnum();

  static String getName(Qualities q) {
    if (q == Qualities.green) {
      return "Grönska";
    } else if (q == Qualities.playground) {
      return "Lekpark";
    } else if (q == Qualities.natureplay) {
      return "Parklek";
    } else if (q == Qualities.calm) {
      return "Tyst";
    } else if (q == Qualities.ballplay) {
      return "Bollspel";
    } else if (q == Qualities.parkplay) {
      return "Vakt finns";
    } else if (q == Qualities.picknick) {
      return "Picknick";
    } else if (q == Qualities.grill) {
      return "Grillplats";
    } else if (q == Qualities.sleigh) {
      return "Släde";
    } else if (q == Qualities.view) {
      return "Fin utsikt";
    } else if (q == Qualities.forest) {
      return "Skog";
    } else if (q == Qualities.animal) {
      return "Djurhållning";
    } else if (q == Qualities.water) {
      return "Vatten";
    } else if (q == Qualities.out_bath) {
      return "Utomhusbad";
    } else if (q == Qualities.nature_expr) {
      return "nature_expr";
    } else if (q == Qualities.out_serve) {
      return "out_serve";
    } else if (q == Qualities.water_play) {
      return "Vattenlek";
    } else if (q == Qualities.bath_f) {
      return "Badhus";
    }
  }

  static Icon getIcon(Qualities q) {
    if (q == Qualities.green) {

    } else if (q == Qualities.playground) {

    } else if (q == Qualities.natureplay) {

    } else if (q == Qualities.calm) {

    } else if (q == Qualities.ballplay) {

    } else if (q == Qualities.parkplay) {

    } else if (q == Qualities.picknick) {

    } else if (q == Qualities.grill) {

    } else if (q == Qualities.sleigh) {

    } else if (q == Qualities.view) {

    } else if (q == Qualities.forest) {

    } else if (q == Qualities.animal) {

    } else if (q == Qualities.water) {

    } else if (q == Qualities.out_bath) {

    } else if (q == Qualities.nature_expr) {

    } else if (q == Qualities.out_serve) {

    } else if (q == Qualities.water_play) {

    } else if (q == Qualities.bath_f) {

    }
  }

  @override
  String toString() {
    return 'ExtendsQualitiesEnum{}';
  }
}

enum Qualities {
  green,
  playground,
  natureplay,
  calm,
  ballplay,
  parkplay,
  picknick,
  grill,
  sleigh,
  view,
  forest,
  animal,
  water,
  out_bath,
  nature_expr,
  out_serve,
  water_play,
  bath_f
}
