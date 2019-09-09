import 'package:flutter/material.dart';

class Reservation {
  String restId;
  String resId;
  int peopleNumber;
  DateTime day;
  TimeOfDay time;

  Reservation({
    this.restId,
    this.resId,
    @required this.peopleNumber,
    @required this.day,
    @required this.time,
  });
}


var demoReservation = Reservation(
  peopleNumber: 2,
  day: DateTime(2019, 9, 8),
  time: TimeOfDay(hour: 12, minute: 15,)
);
