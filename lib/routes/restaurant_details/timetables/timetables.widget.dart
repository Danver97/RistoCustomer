
import 'package:flutter/material.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';

class TimetableWidget extends StatefulWidget {
  final WeekTimetable timetable;

  TimetableWidget(this.timetable);

  @override
  State<StatefulWidget> createState() => TimetableWidgetState();

}

class TimetableWidgetState extends State<TimetableWidget> with TickerProviderStateMixin {
  bool _expanded = false;

  TimetableWidgetState();

  _columnTile(String text, [bool bold]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF95989A), fontWeight: (bold != null && bold) ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  _dayColumn() {
    var timetable = widget.timetable;
    int today = DateTime.now().weekday;
    List<Widget> tiles = [];
    for (var i = 1; i <= 7; i++) {
      tiles.add(_columnTile('${timetable.getDay(i).day.toStringShort()}:', today == i ? true : false));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tiles,
    );
  }

  _timetableColumn(BuildContext context) {
    var timetable = widget.timetable;
    int today = DateTime.now().weekday;
    List<Widget> tiles = [];
    for (var i = 1; i <= 7; i++) {
      tiles.add(_columnTile('${timetable.getDay(i).format(context)}', today == i ? true : false));
    }
    return Column(
      children: tiles,
    );
  }

  _fullTimetable(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _dayColumn(),
            Padding(padding: EdgeInsets.only(left: 8),),
            _timetableColumn(context),
          ],
        ),
      ),
    );
  }

  _todayTimetable(BuildContext context) {
    var today = DateTime.now();
    var todayTimetable = widget.timetable.getDay(today.weekday);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _columnTile('${todayTimetable.day.toStringShort()}:'),
            Padding(padding: EdgeInsets.only(left: 8),),
            _columnTile(todayTimetable.format(context)),
            // Padding(padding: EdgeInsets.only(left: 1),),
          ],
        ),
      ),
    );
  }

  _expandMoreIcon() {
    return Icon(
      Icons.expand_more,
      color: Color(0xFF95989A),
    );
  }
  _expandLessIcon() {
    return Icon(
      Icons.expand_less,
      color: Color(0xFF95989A),
    );
  }

  _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onTap: _toggleExpand,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Color(0xFFF2F2F2),
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.schedule,
                      color: Color(0xFF95989A),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                  ),
                  // _fullTimetable(),
                  // _todayTimetable(),
                  !_expanded ? _todayTimetable(context) : _fullTimetable(context),
                  Padding(
                    padding: EdgeInsets.all(16),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: !_expanded ? _expandMoreIcon() : _expandLessIcon(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
