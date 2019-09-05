import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.widget.dart';

import 'menu.dart';

class MenuSectionWidget extends StatelessWidget {
  final MenuSection section;

  MenuSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text(section.name, style: TextStyle(fontSize: 16)),),
        Padding(padding: EdgeInsets.only(top: 12),),
        DishScrollView(section.dishes),
        Padding(padding: EdgeInsets.only(top: 12),),
      ],
    );
  }

}

class DishScrollView extends StatelessWidget {
  final List<Dish> dishes;
  final double tilesBorderRadius;
  final double tilesHeight;

  DishScrollView(this.dishes, {this.tilesBorderRadius = 16.0, this.tilesHeight = 149});

  @override
  Widget build(BuildContext context) {

    List<Widget> listTiles = [Padding(padding: EdgeInsets.only(left: 16),),];
    dishes.forEach((d) {
      if (listTiles.length > 1)
        listTiles.add(Padding(padding: EdgeInsets.only(left: 8),));
      listTiles.add(DishWidget(d, borderRadius: tilesBorderRadius,));
    });
    listTiles.add(Padding(padding: EdgeInsets.only(left: 16),));

    return Container(
      height: tilesHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: listTiles,
      ),
    );
  }

}

class DishWidget extends StatelessWidget {
  final Dish dish;
  final double borderRadius;

  DishWidget(this.dish, {this.borderRadius = 16.0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Container(
        color: Colors.white,
        width: 170,
        child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            height: 95,
            child: Image.network(dish.imgUrl, fit: BoxFit.cover,),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text(dish.name, maxLines: 1, overflow: TextOverflow.ellipsis,),),
                    Padding(padding: EdgeInsets.only(left: 6),),
                    Text(dish.price.toString(), style: TextStyle(color: Color(0xFF95989A)),),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 6),),
                ReviewStars(dish.review),
              ],
            ),
          )
        ],),

      ),
    );
  }

}
