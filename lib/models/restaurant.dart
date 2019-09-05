import 'package:flutter/foundation.dart';
import 'package:prova/routes/restaurant_details/menu/menu.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';

class Restaurant {
  String name;
  ReviewScore score;
  Menu menu;
  WeekTimetable timetable;
  int priceLevel;
  List<String> type;
  String mainPicture;
  // Position position; // TODO: add geolocator https://pub.dev/packages/geolocator.

  Restaurant({
    @required this.name,
    @required this.score,
    @required this.menu,
    @required this.timetable,
    @required this.priceLevel,
    this.mainPicture,
  });

}

Restaurant demoRestaurant = Restaurant(
  name: 'Playa Cabana',
  score: ReviewScore(4.3),
  menu: demoMenu,
  timetable: demoTimetables,
  priceLevel: 3,
  mainPicture: 'https://www.scripps.org/sparkle-assets/images/mexican_food_1200x750-14c09ee840f1824937cabd4c79bf86b8.jpg',
);
