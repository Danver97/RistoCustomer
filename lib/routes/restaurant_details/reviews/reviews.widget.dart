
import 'package:flutter/material.dart';
import 'package:prova/routes/restaurant_details/reviews/reviews.dart';

class RestaurantReviewsOverview extends StatelessWidget {
  final RestaurantReviews reviews;

  RestaurantReviewsOverview(this.reviews, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          reviews.score.toString(),
          style: TextStyle(fontSize: 48),
        ),
        ReviewStars(reviews),
        Padding(
          padding: EdgeInsets.only(top: 8),
        ),
        Text(reviews.reviewNumber.toString()),
      ],
    );
  }

}

class RestaurantReviewCard extends StatefulWidget {
  final RestaurantReview review;
  final double borderRadius;

  RestaurantReviewCard(this.review, {this.borderRadius = 16.0});

  @override
  State<StatefulWidget> createState() => RestaurantReviewCardState();

}

class RestaurantReviewCardState extends State<RestaurantReviewCard> with TickerProviderStateMixin {
  final double _userImageSize = 36;
  final double _internalPadding = 16;
  bool _expandText = false;
  int _textMaxLines = 3;

  RestaurantReviewCardState();

  _user() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(_userImageSize / 2)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Color(0xFFEBEBEB),
            height: _userImageSize,
            width: _userImageSize,
            // child: Image.network(review.reviewerImg, fit: BoxFit.cover),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: _internalPadding),),
        Text(widget.review.reviewer),
      ],
    );
  }

  _starsAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ReviewStars(widget.review),
        Padding(padding: EdgeInsets.only(left: _internalPadding / 2),),
        Text('10/08/19'),
      ],
    );
  }

  _expandTextReview() {
    setState(() {
          _expandText = !_expandText;
          if (_expandText)
            _textMaxLines = 50;
          else
            _textMaxLines = 3;
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _expandTextReview,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.all(_internalPadding),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _user(),
              Padding(padding: EdgeInsets.only(top: _internalPadding),),
              _starsAndDate(),
              Padding(padding: EdgeInsets.only(top: _internalPadding),),
              AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 100),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment.topCenter,
                child: Text(widget.review.text, maxLines: _textMaxLines, overflow: TextOverflow.fade,),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ReviewStars extends StatelessWidget {
  final ReviewScore review;

  ReviewStars(this.review);

  @override
  Widget build(BuildContext context) {
    Color starColor = Colors.yellow;
    double score2 = review.score;
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
    List<Widget> rowChildren = [/*Text(score.toString(),), Padding(padding: EdgeInsets.all(2),),*/]..addAll(stars);
    // rowChildren
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: rowChildren,
    );
  }

}
