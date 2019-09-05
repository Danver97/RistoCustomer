
import 'package:flutter/material.dart';
import 'package:prova/grid.widget.dart' as prefix0;
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';


class DemoHourPicker extends StatelessWidget {
  final DateTime day;
  final Function onHourChanged;
  final Function onHourSelected;
  final Function onHourDeselected;

  DemoHourPicker({this.day, this.onHourChanged, this.onHourSelected, this.onHourDeselected});

  @override
  Widget build(BuildContext context) {
    return HourPicker(
      day: day,
      dayTimetable: demoTimetables.getDay(4),
      onHourChanged: onHourChanged,
      onHourSelected: onHourSelected,
      onHourDeselected: onHourDeselected,
    );
  }

}

class HourPicker extends StatefulWidget {
  final TimeOfDay initialHourSelected;
  final DateTime day;
  final DayTimetable dayTimetable;
  final Function onHourChanged;
  final Function onHourSelected;
  final Function onHourDeselected;

  HourPicker({this.day, @required this.dayTimetable, this.initialHourSelected, this.onHourChanged, this.onHourSelected, this.onHourDeselected});

  @override
  State<StatefulWidget> createState() => HourPickerState();

}

class HourPickerState extends State<HourPicker> {
  TimeOfDay hourSelected;

  initState() {
    super.initState();
    hourSelected = widget.initialHourSelected;
  }

  _onHourSelected(TimeOfDay hour) {
    if (widget.onHourSelected != null)
      widget.onHourSelected(hour);
  }
  _onHourDeselected() {
    if (widget.onHourDeselected != null)
      widget.onHourDeselected();
  }
  _onHourChanged(TimeOfDay hour) {
    if (widget.onHourChanged != null)
        widget.onHourChanged(hourSelected);
  }

  _onHourTapped(TimeOfDay hour) {
    setState(() {
      if (hourSelected == hour) {
        hourSelected = null;
        _onHourDeselected();
      } else {
        hourSelected = hour;
        _onHourSelected(hourSelected);
      }
      _onHourChanged(hourSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timetablesStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Lunch', style: timetablesStyle),),
        HourPickerGrid(
          day: widget.day,
          timeround: widget.dayTimetable.timerounds[0],
          hourSelected: hourSelected,
          onHourTapped: _onHourTapped,
        ),
        Padding(padding: EdgeInsets.only(top: 16),),
        Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Dinner', style: timetablesStyle),),
        HourPickerGrid(
          day: widget.day,
          timeround: widget.dayTimetable.timerounds[1],
          hourSelected: hourSelected,
          onHourTapped: _onHourTapped,
        ),
      ],
    );
  }

}

class HourPickerGrid extends StatelessWidget {

  final DateTime day;
  final TimeRound timeround;
  final Function onHourTapped;
  final TimeOfDay hourSelected;
  final int tilesPerRow = 5;
  final DateTime defaultDay = DateTime(1970, 1, 1);

  HourPickerGrid({@required this.timeround, @required this.day, this.hourSelected, this.onHourTapped});

  // Ritorna vero se il time combinato con il day scelto è precedente a now.
  _dayTimeIsPreviousNow(DateTime day, TimeOfDay time) {

    var actualDay = day ?? defaultDay;

    var now = DateTime.now();
    var dayTime = DateTime(actualDay.year, actualDay.month, actualDay.day, time.hour, time.minute);
    if (dayTime.compareTo(now) > 0)
      return false;
    return true;
  }

  _endOfTimeCursor(TimeOfDay time, int hoursAfter, int minutesAfter) {
    int hour = 0;
    int minute = 0;

    if (time.hour + hoursAfter >= 24)
      hour = time.hour + hoursAfter - 24;
    else if (time.hour + hoursAfter < 0)
      hour = time.hour + hoursAfter + 24;
    else 
      hour = time.hour + hoursAfter;

    if (time.minute + minutesAfter >= 60)
      minute = time.minute + minutesAfter - 60;
    else if (time.minute + minutesAfter < 0)
      minute = time.minute + minutesAfter + 60;
    else 
      minute = time.minute + minutesAfter;
    
    return TimeOfDay(hour: hour, minute: minute);
  }

  _onHourTapped(TimeOfDay hour) {
    if (onHourTapped != null)
      onHourTapped(hour);
  }

  prefix0.GridIterator _gridIterator() {
    var closing = timeround.closing;

    var timeCursor = timeround.opening;
    var endOfTimeCursor = _endOfTimeCursor(closing, -1, 15);
    var iterations = 0;

    Widget next() {
      var nextTile;
      if (_dayTimeIsPreviousNow(day, timeCursor))
        nextTile = HourGirdTile(hour: timeCursor, active: false, onTap: _onHourTapped,);
      else
        nextTile = HourGirdTile(hour: timeCursor, active: true, selected: hourSelected == timeCursor, onTap: _onHourTapped,);
      
      // Aggiorna la condizione di termine
      if (timeCursor.minute + 15 >= 60)
        timeCursor = TimeOfDay(hour: timeCursor.hour + 1, minute: 0);
      else
        timeCursor = TimeOfDay(hour: timeCursor.hour, minute: timeCursor.minute + 15);
      iterations++;

      return nextTile;
    }

    bool stop() {
      return !(timeCursor != endOfTimeCursor && iterations < 20);
    }

    return prefix0.GridIterator(stop: stop, next: next);
  }

  @override
  Widget build(BuildContext context) {
    return prefix0.Grid(
      tilesPerRow: tilesPerRow,
      iterator: _gridIterator(),
    );
  }

}

class HourGirdTile extends StatelessWidget {
  final TimeOfDay hour;
  final bool active;
  final bool selected;
  final Function onTap;
  
  HourGirdTile({@required this.hour, @required this.active, this.selected = false, this.onTap});

  _onTap(String text) {
    if (onTap != null)
      onTap(hour);
  }

  @override
  Widget build(BuildContext context) {
    var onTap = (active && this.onTap != null) ? _onTap : null;

    return prefix0.TextGridTile(text: hour.format(context), active: active, selected: selected, onTap: onTap,);
  }

}
