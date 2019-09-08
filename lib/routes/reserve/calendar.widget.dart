import 'package:flutter/material.dart';
import 'package:prova/grid.widget.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';

class Calendar extends StatefulWidget {
  final WeekTimetable timetable;
  final DateTime initialDayPicked;
  final Function onDayChanged;
  final Function onDaySelected;
  final Function onDayDeselected;

  Calendar({@required this.timetable, this.initialDayPicked, this.onDayChanged, this.onDaySelected, this.onDayDeselected});

  @override
  State<StatefulWidget> createState() => CalendarState();

}

class CalendarState extends State<Calendar> {
  DateTime timeCursor;
  DateTime dayPicked;

  initState() {
    super.initState();
    dayPicked = widget.initialDayPicked;
    timeCursor = widget.initialDayPicked ?? DateTime.now();
  }

  _header(String month, String year) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(child: Icon(Icons.chevron_left), onTap: _prevMonth,),
        // TODO: tradurre month da numero a stringa (es. 8 -> August)
        Text('$month $year', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        GestureDetector(child: Icon(Icons.chevron_right), onTap: _nextMonth,),
      ],
    );
  }

  _prevMonth() {
    setState(() {
      timeCursor = DateTime(timeCursor.year, timeCursor.month - 1);
    });
  }

  _nextMonth() {
    setState(() {
      timeCursor = DateTime(timeCursor.year, timeCursor.month + 1);
    });
  }

  _onDayChanged(DateTime day) {
    setState(() {
      dayPicked = day;
      if (widget.onDayChanged != null)
        widget.onDayChanged(dayPicked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _header(timeCursor.month.toString(), timeCursor.year.toString()),
        Padding(padding: EdgeInsets.only(top: 16),),
        CalendarGrid(
          year: timeCursor.year,
          month: timeCursor.month,
          timetable: widget.timetable,
          initialDayPicked: widget.initialDayPicked,
          onDayChanged: _onDayChanged,
          onDaySelected: widget.onDaySelected,
          onDayDeselected: widget.onDayDeselected,
        ),
      ],
    );
  }
}

class CalendarGrid extends StatefulWidget {
  final int year;
  final int month;
  final WeekTimetable timetable;
  final DateTime initialDayPicked;
  final Function onDayChanged;
  final Function onDaySelected;
  final Function onDayDeselected;

  CalendarGrid({
    @required this.year,
    @required this.month,
    @required this.timetable,
    this.initialDayPicked,
    this.onDayChanged,
    this.onDaySelected,
    this.onDayDeselected
  });

  @override
  State<StatefulWidget> createState() => CalendarGridState();

}

class CalendarGridState extends State<CalendarGrid> {
  DateTime day;
  final int tilesPerRow = 7;
  
  
  initState() {
    super.initState();
    day = widget.initialDayPicked;
  }

  _onDayTapped(int day) {
    setState(() {
      if (this.day != null && DateTime(widget.year, widget.month, day).difference(this.day).inDays == 0) {
        this.day = null;
        _onDayDeselected();
        _onDayChanged(this.day);
      } else {
        this.day = DateTime(widget.year, widget.month, day);
        _onDaySelected(this.day);
        _onDayChanged(this.day);
      }
    });
  }

  _onDaySelected(DateTime value) {
    if (widget.onDaySelected != null)
      widget.onDaySelected(value);
  }
  _onDayDeselected() {
    if (widget.onDayDeselected != null)
      widget.onDayDeselected();
  }
  _onDayChanged(DateTime value) {
    if (widget.onDayChanged != null)
      widget.onDayChanged(value);
  }

  int _initialPadding() {
    var today = DateTime.now();
    var firstWeekdayOfMonth = DateTime(today.year, widget.month, 1).weekday;
    return firstWeekdayOfMonth - 1;
  }

  _gridIterator() {
    var beginningNextMonth = DateTime(widget.year, widget.month + 1, 1);
    var lastDayOfMonth = beginningNextMonth.subtract(new Duration(days: 1)).day;

    var i = 1;

    Widget next() {
      var currentDay = DateTime(widget.year, widget.month, i); // Day will be displayed in current iteration
      bool activeTile = _getActiveTileFlag(currentDay);
      bool selectedTile = day != null ? currentDay.difference(day).inDays == 0 : false;
      var widgetTile = CalendarDayGridTile(day: i, active: activeTile, selected: selectedTile, onTap: _onDayTapped,);
      i++;
      return widgetTile;
    }

    bool stop() {
      return i >= lastDayOfMonth + 1;
    }

    return GridIterator(stop: stop, next: next);

  }

  bool _getActiveTileFlag(DateTime currentDay) {
    // If currentDay is previous to today or on currentDay restaurant is closed, 
    // the tile must be inactive (aka activeFlag = false).
    var today = DateTime.now();
    if (currentDay.difference(today).inDays < 0 || widget.timetable.getDay(currentDay.weekday).isClosed())
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Grid(
      tilesPerRow: tilesPerRow,
      initialTilesPadding: _initialPadding(),
      iterator: _gridIterator(),
    );
  }

}

class CalendarDayGridTile extends StatelessWidget {
  final int day;
  final bool active;
  final bool selected;
  final Function onTap;

  CalendarDayGridTile({@required this.day, @required this.active, this.selected = false, this.onTap});

  _onTap(String text) {
    if (onTap != null)
      onTap(day);
  }

  @override
  Widget build(BuildContext context) {
    var onTap = (active && this.onTap != null) ? _onTap : null;

    return TextGridTile(text: day.toString(), active: active, selected: selected, onTap: onTap,);
  }

}
