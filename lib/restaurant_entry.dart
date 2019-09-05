import 'package:flutter/material.dart';



abstract class RestaurantEntry extends StatelessWidget {
  RestaurantEntry({Key key}): super(key: key);
}

class FlatRestaurantEntry extends RestaurantEntry {
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final String restaurantName;
  final String restaurantType;
  final String expensiveness;
  final double reviewScore;
  final String distance;
  final String imageUrl;
  final Function onTap;
  final String demoImgUrl = 'https://d22ir9aoo7cbf6.cloudfront.net/wp-content/uploads/sites/2/2018/10/Saltwater-Halal-Restaurants-Singapore.png';

  FlatRestaurantEntry({
    Key key,
    this.margin,
    this.borderRadius = 16.0,
    this.restaurantName = 'Playa Cabana',
    this.restaurantType = 'Mexican',
    this.expensiveness = '€€',
    this.reviewScore = 4.5,
    this.distance = '500m',
    this.imageUrl,
    this.onTap,
  }): super(key: key);

  _topImage(src) {
    return Container(
      width: double.infinity,
      height: 150,
      child: Image.network(src, fit: BoxFit.cover,),
    );
  }

  _reviewScore({score}) {
    Color starColor = Colors.yellow;
    double score2 = score;
    List<Widget> stars = [];
    for (var i = 0; i < 5; i++) {
      if (score2 >= 1)
        stars.add(Icon(Icons.star, color: starColor, size: 16,));
      else if (score2 > 0 && score2 < 1)
        stars.add(Icon(Icons.star_half, color: starColor, size: 16,));
      else 
        stars.add(Icon(Icons.star_border, color: starColor, size: 16,));
      score2 -= 1;
    }
    List<Widget> rowChildren = [Text(score.toString(),), Padding(padding: EdgeInsets.all(2),),]..addAll(stars);
    // rowChildren
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: rowChildren,
    );
  }

  _title({restaurantName}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          restaurantName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _distance({distance, color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.place, size: 16, color: color),
        Padding(padding: EdgeInsets.all(2),),
        Text(distance, style: TextStyle(color: color),),
      ],
    );
  }

  _typeExpensivenessText({type = 'Mexican', expensiveness = '€€'}) {
    return Text('$type · $expensiveness · ');
  }

  _bottomContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(restaurantName: this.restaurantName),
          Padding(padding: EdgeInsets.all(4),),
          Row(children: <Widget>[
            _typeExpensivenessText(type: this.restaurantType, expensiveness: this.expensiveness),
            _reviewScore(score: this.reviewScore),
          ],),
          Padding(padding: EdgeInsets.all(4),),
            _distance(distance: this.distance, color: Color(0x88000000)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        margin: this.margin != null ? this.margin : EdgeInsets.all(16.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _topImage(imageUrl != null ? imageUrl : demoImgUrl),
              _bottomContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CardRestaurantEntry extends RestaurantEntry {
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final String restaurantName;
  final String restaurantType;
  final String expensiveness;
  final double reviewScore;
  final String distance;
  final String imageUrl;
  final Function onTap;

  CardRestaurantEntry({
    Key key,
    this.margin,
    this.borderRadius = 16.0,
    this.restaurantName = 'Playa Cabana',
    this.restaurantType = 'Mexican',
    this.expensiveness = '€€',
    this.reviewScore = 4.5,
    this.distance = '500m',
    this.imageUrl,
    this.onTap,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: this.margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.borderRadius),
      ),
      child: FlatRestaurantEntry(
        margin: EdgeInsets.all(0),
        borderRadius: this.borderRadius,
        restaurantName: this.restaurantName,
        restaurantType: this.restaurantType,
        expensiveness: this.expensiveness,
        reviewScore: this.reviewScore,
        distance: this.distance,
        imageUrl: this.imageUrl,
        onTap: this.onTap,
      ),
    );
  }

}

class RestaurantList extends StatelessWidget {
  final List<RestaurantEntry> children;
  final EdgeInsetsGeometry padding;

  RestaurantList({this.padding, this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: this.padding,
        children: this.children,
    );
  }

}
