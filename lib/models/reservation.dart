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

  Map<String, dynamic> toJson() {
    return {
      'restId': restId,
      'resId': resId,
      'peopleNumber': peopleNumber,
      'date': DateTime(day.year, day.month, day.day, time.hour, time.minute).toUtc().toIso8601String(),
    };
  }
}


var demoReservation = Reservation(
  peopleNumber: 2,
  day: DateTime(2019, 9, 8),
  time: TimeOfDay(hour: 12, minute: 15,)
);
