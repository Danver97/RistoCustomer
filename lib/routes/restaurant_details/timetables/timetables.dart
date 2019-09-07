import 'package:flutter/material.dart';

class TimeRound {
  TimeOfDay opening;
  TimeOfDay closing;

  TimeRound(this.opening, this.closing);

  static fromJson(json) {
    var re = RegExp(r"(\d\d):(\d\d)");
    var matchOpening = re.allMatches(json['opening']).elementAt(0);
    var matchClosing = re.allMatches(json['closing']).elementAt(0);
    var opening = TimeOfDay(hour: int.parse(matchOpening.group(1)), minute: int.parse(matchOpening.group(2)));
    var closing = TimeOfDay(hour: int.parse(matchClosing.group(1)), minute: int.parse(matchClosing.group(2)));
    return TimeRound(opening, closing);
  }

  static fromStringTime(String open, String close) {
    var parser = RegExp(r'^(\d\d)(?:\:|-|\.)(\d\d)$');
    var openH = parser.firstMatch(open).group(1);
    var openM = parser.firstMatch(open).group(2);
    var closeH = parser.firstMatch(close).group(1);
    var closeM = parser.firstMatch(close).group(2);
    return TimeRound(
      TimeOfDay(hour: int.parse(openH), minute: int.parse(openM)),
      TimeOfDay(hour: int.parse(closeH), minute: int.parse(closeM)),
    );
  }

  String format(BuildContext context) {
    return '${opening.format(context)} - ${closing.format(context)}';
  }
}

class DayTimetable {
  DayOfWeek day;
  List<TimeRound> timerounds;

  DayTimetable(int day, [this.timerounds]) {
    this.day = DayOfWeek(day);
  }

  addRound(TimeRound round) {
    if (timerounds == null)
      timerounds = [];
    if (timerounds.length >= 2)
      return;
    timerounds.add(round);
  }

  isClosed() {
    return timerounds == null || timerounds.isEmpty;
  }

  String format(BuildContext context) {
    return (timerounds == null || timerounds.isEmpty) ? 'Closed' : timerounds.map((t) => t.format(context)).join(' · ');
  }
}

class DayOfWeek {
  int day;
  DayOfWeek(this.day);

  @override
  String toString() {
    switch(this.day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
    }
    return '';
  }

  String toStringShort() {
    switch(this.day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return '';
  }
}

class WeekTimetable {
  var dayrounds = [];

  WeekTimetable([this.dayrounds]);

  static fromJson(json) {
    WeekTimetable timetable = WeekTimetable();
    json.keys.forEach((k) {
      int day = int.parse(k);
      var dayTimetable = DayTimetable(day);
      json[k].forEach((e) {
        var timeround = TimeRound.fromJson(e);
        dayTimetable.addRound(timeround);
      });
      timetable.addDay(dayTimetable);
    });

    return timetable;
  }

  addDay(DayTimetable day) {
    if (dayrounds == null)
      dayrounds = [];
    dayrounds.add(day);
    dayrounds.sort((a, b) {
      return a.day.day > b.day.day ? -1 : 1;
    });
  }

  DayTimetable getDay(int day){
    return dayrounds[day-1];
  }
}

var demoTimetables = WeekTimetable([
  DayTimetable(1),
  DayTimetable(2, []),
  DayTimetable(3, [
    TimeRound.fromStringTime('11:30', '15:30'), // TimeRound('11:30', '15:30')
    TimeRound.fromStringTime('18:30', '23:00'),
  ]),
  DayTimetable(4, [
    TimeRound.fromStringTime('11:30', '15:30'),
    TimeRound.fromStringTime('18:30', '23:00'),
  ]),
  DayTimetable(5, [
    TimeRound.fromStringTime('11:30', '15:30'),
    TimeRound.fromStringTime('18:30', '23:00'),
  ]),
  DayTimetable(6, [
    TimeRound.fromStringTime('11:30', '15:30'),
    TimeRound.fromStringTime('18:30', '23:00'),
  ]),
  DayTimetable(7, [
    TimeRound.fromStringTime('11:30', '15:30'),
    TimeRound.fromStringTime('18:30', '23:00'),
  ]),
]);

