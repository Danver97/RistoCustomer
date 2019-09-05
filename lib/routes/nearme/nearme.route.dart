import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:prova/routes/restaurant_details/restaurant_details.route.dart';
import 'dart:convert';

import 'package:prova/restaurant_entry.dart';

// TODO: implementare funzione di ricerca e filtraggio

class NearmeRoute extends StatelessWidget {

  static final String routeName = '/nearme';

  Future<List<Post>> fetchRestaurant() async {
    final response =
        await get('https://jsonplaceholder.typicode.com/posts/');

    if (response.statusCode == 200) {
      List<Post> posts = [];
      var decodedJson = json.decode(response.body);
      decodedJson.forEach((d) {
        var post = Post.fromJson(d);
        posts.add(post);
      });
      return posts;
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
          child: FutureBuilder<List<Post>>( // Turns async code in sync widget visualization
            future: fetchRestaurant(),
            builder: (context, snapshot) {

              // If future completed successfully
              if (snapshot.hasData) {

                return RestaurantList(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  children: snapshot.data.map((d) {
                    return FlatRestaurantEntry(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      restaurantName: d.title.substring(0, 30 < d.title.length ? 30 : d.title.length),
                      onTap: () {
                        Navigator.pushNamed(context, RestaurantDetailsRoute.routeName);
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

// TODO: cambiare con una classe per i ristoranti
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
