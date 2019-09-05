class ReviewScore {
  double score;

  ReviewScore(this.score);
}

class RestaurantReviews extends ReviewScore {
  int reviewNumber;
  List<RestaurantReview> reviews;

  RestaurantReviews(double score, this.reviewNumber, [this.reviews]): super(score);
}

class RestaurantReview extends ReviewScore {
  String reviewer;
  String text;
  
  RestaurantReview(this.reviewer, score, [this.text]): super(score);
}


// Demo data
String _loremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed do eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrum exercitationem ullamco laboriosam, nisi ut aliquid ex ea commodi consequatur. Duis aute irure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

RestaurantReviews demoReviews = RestaurantReviews(4.5, 1648, <RestaurantReview>[
  RestaurantReview('Michele Fraccalvieri', 4.3, _loremIpsum),
  RestaurantReview('Mario Grasso', 3.0, _loremIpsum),
  RestaurantReview('Enzo Fracchi', 2.0, _loremIpsum),
]);
