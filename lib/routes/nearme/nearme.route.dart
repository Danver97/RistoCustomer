import 'package:flutter/material.dart';
import 'package:prova/api/nearme.api.dart';
import 'package:prova/models/restaurant.dart';
import 'package:prova/routes/restaurant_details/restaurant_details.route.dart';
import 'dart:convert';

import 'package:prova/routes/nearme/restaurant_entry.widget.dart';

// TODO: implementare funzione di ricerca e filtraggio

class NearmeRoute extends StatelessWidget {

  static final String routeName = '/nearme';

  Future<List<Restaurant>> fetchRestaurant() async {
    final response2 = await NearmeApi.nearmeRestaurants();

    if (response2.statusCode == 200) {
      List<Restaurant> restaurants = [];
      var decodedJson = json.decode(response2.body);
      decodedJson.forEach((d) {
        var restaurant = Restaurant.fromJson(d);
        restaurants.add(restaurant);
      });
      return restaurants;
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Near me'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white,),
              onPressed: () {
                // Navigator.pushNamed(context, '/nearme/search');
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white,),
              onPressed: () {
                // Navigator.pushNamed(context, '/nearme/filters');
              },
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder<List<Restaurant>>( // Turns async code in sync widget visualization
            future: fetchRestaurant(),
            builder: (context, snapshot) {

              // If future completed successfully
              if (snapshot.hasData) {

                return RestaurantList(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  children: snapshot.data.map((r) {
                    return FlatRestaurantEntry(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      restaurant: r,
                      restaurantName: r.name,
                      onTap: () {
                        Navigator.pushNamed(context, RestaurantDetailsRoute.routeName, arguments: r);
                      },
                    );
                  }).toList(),
                );

              // If future completed with error
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator(); // TODO: cambiare con una visualizzazione flat delle schede ristoranti
            },
          ),
        ),
      );
}
