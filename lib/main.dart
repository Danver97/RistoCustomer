import 'package:flutter/material.dart';
import 'package:prova/routes/nearme/nearme.route.dart';
import 'package:prova/routes/reserve/reserve.route.dart';
import 'package:prova/routes/restaurant_details/restaurant_details.route.dart';
// import 'dart:developer';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risto',
      theme: ThemeData(
        // Add the 3 lines from here...
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
        // primarySwatch: Colors.blue,
      ),
      initialRoute: '/restaurant',
      routes: {
        '/': (context) => NearmeRoute(),
        '/restaurant': (context) => RestaurantDetailsRoute(),
        '/restaurant/reserve': (context) => ReserveRoute(),
      }
      // home: NearmeRoute(),// RestaurantDetailsRoute(),
    );
  }
}
