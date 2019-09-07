import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prova/routes/restaurant_details/menu/menu.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';

class Restaurant {
  String restId;
  String name;
  ReviewScore score;
  Menu menu;
  WeekTimetable timetable;
  int priceLevel;
  List<String> type;
  String mainPicture;
  // Position position; // TODO: add geolocator https://pub.dev/packages/geolocator.

  Restaurant({
    @required this.restId,
    @required this.name,
    @required this.score,
    @required this.menu,
    @required this.timetable,
    @required this.priceLevel,
    this.mainPicture,
  });

  static fromJson(json) {
    var restId = json['restId'];
    var name = json['name'];
    var score = json['score'];
    var priceLevel = json['priceLevel'];
    var mainPicture = json['mainPicture'];

    WeekTimetable timetable = WeekTimetable.fromJson(json['timetable']);
    Menu menu = Menu.fromJson(json['menu']);

    return Restaurant(
      restId: restId,
      name: name,
      score: score,
      priceLevel: priceLevel,
      menu: menu,
      timetable: timetable,
      mainPicture: mainPicture,
    );
  }

}

Restaurant demoRestaurant = Restaurant(
  restId: 'aaaaaaabbbbbbbbbbbb',
  name: 'Playa Cabana',
  score: ReviewScore(4.3),
  menu: demoMenu,
  timetable: demoTimetables,
  priceLevel: 3,
  mainPicture: 'https://www.scripps.org/sparkle-assets/images/mexican_food_1200x750-14c09ee840f1824937cabd4c79bf86b8.jpg',
);
