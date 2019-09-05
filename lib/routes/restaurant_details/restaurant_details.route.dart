import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prova/models/restaurant.dart';
import 'package:prova/routes/reserve/reserve.route.dart';
import 'package:prova/routes/restaurant_details/menu/menu.widget.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.widget.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.widget.dart';

class RestaurantDetailsRoute extends StatelessWidget {

  static final String routeName = '/restaurant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RestaurantDetailsScrollView(restaurant: demoRestaurant, reviews: demoReviews,),
    );
  }
}

class RestaurantDetailsScrollView extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantReviews reviews;

  RestaurantDetailsScrollView({@required this.restaurant, @required this.reviews});

  _appBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Opacity(
            opacity: 0.6,
            child: Image.network(
              restaurant.mainPicture,
              fit: BoxFit.cover,
            )),
        title: Text(restaurant.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: <Widget>[
          _appBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Details(restaurant: restaurant, reviews: reviews),
              ]
            ),
          ),
        ],
      );
  }

}

class Details extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantReviews reviews;

  Details({@required this.restaurant, @required this.reviews});

  _fab({String label, Icon icon, Color fabColor, Function onPressed}) {
    return Container(
      // color: Colors.purple,
      width: 80,
      child: Theme(
        data: ThemeData(accentColor: fabColor),
        child: Column(
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'fab$label',
              clipBehavior: Clip.antiAlias,
              child: icon,
              onPressed: onPressed,
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Text(
              label,
              style: TextStyle(color: Color(0xFF686868)),
            ),
          ],
        ),
      ),
    );
  }

  _fabs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _fab(
              icon: Icon(
                Icons.schedule,
                color: Colors.white,
              ),
              fabColor: Color(0xFFFFA200),
              label: 'Reservation',
              onPressed: () {
                Navigator.pushNamed(context, ReserveRoute.routeName, arguments: restaurant.timetable);
              }),
          _fab(
              icon: Icon(
                Icons.local_pizza,
                color: Colors.white,
              ),
              fabColor: Color(0xFFF34C21),
              label: 'Take away'),
          _fab(
              icon: Icon(
                Icons.local_shipping,
                color: Colors.white,
              ),
              fabColor: Color(0xFF008F21),
              label: 'Delivery'),
          _fab(
              icon: Icon(
                Icons.drive_eta,
                color: Colors.white,
              ),
              fabColor: Colors.blue,
              label: 'Road to'),
        ],
      ),
    );
  }

  _section(
      {String sectionName,
      bool moreButton = false,
      Function onMorePressed,
      Widget child}) {
    List<Widget> headerWidgets = [
      Expanded(
        child: Text(
          sectionName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    if (moreButton)
      headerWidgets.add(FlatButton(
        child: Text('MORE'),
        onPressed: onMorePressed,
      ));
    List<Widget> columnWidgets = [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: headerWidgets,
        ),
      ),
    ];
    if (child != null) columnWidgets.add(child);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: columnWidgets,
      ),
    );
  }

  _menu() {
    return _section(
      sectionName: 'Menù',
      moreButton: true,
      onMorePressed: () {
        print('Menù more button pressed');
      },
      child: Column(
        children: restaurant.menu.sections.map((s) => MenuSectionWidget(s)).toList(),
        // children: <Widget>[MenuSectionWidget(restaurant.menu.sections[0])],
      ),
    );
  }

  _reviews() {
    List<Widget> widgets = [RestaurantReviewsOverview(reviews),];
    reviews.reviews.forEach((r) {
      widgets.add(Padding(padding: EdgeInsets.only(top: 16),));
      widgets.add(RestaurantReviewCard(r));
    });
    return _section(
      sectionName: 'Reviews',
      moreButton: true,
      onMorePressed: () {
        print('Menù more button pressed');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
        children: widgets,
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(/* horizontal: 16, */ vertical: 8),
      child: Column(
        children: <Widget>[
          TimetableWidget(restaurant.timetable),
          _fabs(context),
          _menu(),
          _reviews(),
          /* _section(
            sectionName: 'Photos',
          ),*/
        ],
      ),
    );
  }
}
