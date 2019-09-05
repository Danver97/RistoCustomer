import 'package:flutter/material.dart';

class ReservationBox extends StatelessWidget {
  final double borderRadius;
  final Color accentBackgroudColor = Color(0xFFFFA200);

  ReservationBox({Key key, this.borderRadius = 16.0}): super(key: key);

  _customTheme(child) {
    return Theme(
      data: ThemeData(primaryColor: accentBackgroudColor),
      child: child,
    );
  }

  _topContainer(color) {
    return Container(
      color: accentBackgroudColor,
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Icon(Icons.schedule, size: 32.0, color: Colors.white,),
          ),
          Text('Reservation', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  _bottomContainer(color) {
    return Container(
      color: color,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      // padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          _customTheme(TextFormField(
            decoration: InputDecoration(
              hintText: 'Number of people',
              icon: Icon(Icons.people),
            ),
            keyboardType: TextInputType.number,
          )),
          _customTheme(TextFormField(
              decoration: InputDecoration(
                hintText: 'Martedì 24 Agosto 16:00',
                icon: Icon(Icons.schedule),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(child: Text('CANCEL'), onPressed: () {},),
                FlatButton(child: Text('OK'), onPressed: () {},),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _mainContainer() {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: double.infinity, child: _topContainer(Colors.yellow)),
            _bottomContainer(Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainContainer();
  }
}

class CardReservationBox extends StatelessWidget {
  final double borderRadius;

  CardReservationBox({Key key, this.borderRadius = 16.0}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.borderRadius),
      ),
      child: ReservationBox(borderRadius: this.borderRadius,),
    );
  }
}
