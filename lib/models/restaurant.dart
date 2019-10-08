import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prova/routes/restaurant_details/menu/menu.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';

class PriceLevel {
  int level;
  String strLevel;

  PriceLevel(this.level) {
    var str = '';
    for (var i = 0; i < level; i++) {
      str += '€';
    }
    this.strLevel = str;
  }

  int toNumber() {
    return this.level;
  }

  int toInt() {
    return this.level;
  }

  @override
  String toString() {
    return strLevel;
  }
}

class Restaurant {
  String restId;
  String name;
  ReviewScore reviewScore;
  Menu menu;
  WeekTimetable timetable;
  PriceLevel priceLevel;
  List<String> types;
  String mainPicture;
  // Position position; // TODO: add geolocator https://pub.dev/packages/geolocator.

  Restaurant({
    @required this.restId,
    @required this.name,
    @required this.reviewScore,
    @required this.menu,
    @required this.timetable,
    @required this.priceLevel,
    @required this.types,
    this.mainPicture,
  });

  static fromJson(json) {
    var restId = json['restId'] ?? json['id'];
    var name = json['name'] ?? json['restaurantName'];
    var score = ReviewScore(json['reviewScore'].toDouble());
    var types = json['type'].cast<String>().toList();
    var mainPicture = json['mainPicture'];
    var priceLevel = PriceLevel(json['priceLevel']);

    WeekTimetable timetable = WeekTimetable.fromJson(json['timetable']);
    Menu menu = Menu.fromJson(json['menu']);

    return Restaurant(
      restId: restId,
      name: name,
      reviewScore: score,
      menu: menu,
      timetable: timetable,
      priceLevel: priceLevel,
      types: types,
      mainPicture: mainPicture,
    );
  }

}

Restaurant demoRestaurant = Restaurant(
  restId: 'aaaaaaabbbbbbbbbbbb',
  name: 'Playa Cabana',
  reviewScore: ReviewScore(4.3),
  menu: demoMenu,
  timetable: demoTimetables,
  priceLevel: PriceLevel(3),
  types: ['Mexican', 'Spicy'],
  mainPicture: 'https://www.scripps.org/sparkle-assets/images/mexican_food_1200x750-14c09ee840f1824937cabd4c79bf86b8.jpg',
);
