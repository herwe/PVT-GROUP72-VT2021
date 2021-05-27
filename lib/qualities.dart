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

var _map = {
  Qualities.green: "Grönska",
  Qualities.playground: "Lekpark",
  Qualities.natureplay: "Parklek",
  Qualities.calm: "Tyst",
  Qualities.ballplay: "Bollspel",
  Qualities.parkplay: "Vakt finns",
  Qualities.picknick: "Picknick",
  Qualities.grill: "Grill",
  Qualities.sleigh: "Pulka",
  Qualities.view: "Fin utsikt",
  Qualities.forest: "Skog",
  Qualities.animal: "Djurhållning",
  Qualities.water: "Vatten",
  Qualities.out_bath: "Utomhusbad",
  Qualities.nature_expr: "Natur Upplevelse",
  Qualities.out_serve: "Uteservering",
  Qualities.water_play: "Vattenlek",
  Qualities.bath_f: "Badhus"
};

extension QualitiesExtension on Qualities {
  String get formatted {
    return _map[this];
  }
}
