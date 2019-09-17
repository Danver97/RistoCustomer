import 'package:flutter/material.dart';

class Reservation {
  String restId;
  String resId;
  int peopleNumber;
  DateTime day;
  TimeOfDay time;

  // TODO: far si che restId sia richiesto e gestire il suo ottenimento nella reserve.route
  Reservation({
    @required this.restId,
    this.resId,
    @required this.peopleNumber,
    @required this.day,
    @required this.time,
  });

  Map<String, dynamic> toJson() {
    var json = {
      'restId': restId,
      'peopleNumber': peopleNumber,
      'userId': 'testUserId',
      'reservationName': 'testReservationName',
      'date': DateTime(day.year, day.month, day.day, time.hour, time.minute).toUtc().toIso8601String(),
    };
    if (resId != null)
      json['resId'] = resId;
    return json;
  }
}


var demoReservation = Reservation(
  restId: '0eb893e2-c57c-4996-a5c5-0fd30da5be88',
  peopleNumber: 2,
  day: DateTime(2019, 9, 8),
  time: TimeOfDay(hour: 12, minute: 15,)
);
