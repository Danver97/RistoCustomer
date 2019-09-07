import 'package:prova/routes/restaurant_details/reviews/reviews.dart';

class Menu {
  List<MenuSection> sections = [];

  Menu([this.sections]);

  static fromJson(json) {
    Menu menu = Menu();

    json.keys.forEach((k) {
      var section = MenuSection(k);
      json[k].forEach((e) {
        var dish = Dish.fromJson(e);
        section.addDish(dish);
      });
      menu.addSection(section);
    });
  }

  addSection(MenuSection section) {
    if (this.sections == null)
      this.sections = [];
    this.sections.add(section);
  }

  addSections(List<MenuSection> sections) {
    if (this.sections == null)
      this.sections = [];
    this.sections.addAll(sections);
  }
}

class MenuSection {
  String name;
  List<Dish> dishes = [];

  MenuSection(this.name, [this.dishes]);

  addDish(Dish dish) {
    if (this.dishes == null)
      this.dishes = [];
    this.dishes.add(dish);
  }

  addDishes(List<Dish> dishes) {
    if (this.dishes == null)
      this.dishes = [];
    this.dishes.addAll(dishes);
  }
}

class Dish {
  String name;
  String imgUrl;
  Price price;
  ReviewScore review;

  Dish(this.name, this.imgUrl, this.price, this.review);

  static fromJson(json) {
    var price = Price(json['price']['currency'], json['price']['value']);
    var review = ReviewScore(json['review'].toDouble());
    return Dish(json['name'], json['imgUrl'], price, review);
  }
}

class Price {
  String currency;
  double price;

  Price(this.currency, this.price);

  @override
  String toString() {
    return '$currency $price';
  }
}


Menu demoMenu = Menu(<MenuSection>[
  MenuSection('First dishes', <Dish>[
    Dish(
      'Tacos',
      'https://d1doqjmisr497k.cloudfront.net/-/media/mccormick-us/recipes/mccormick/f/800/fiesta_tacos_800x800.jpg',
      Price('€', 7.59),
      ReviewScore(4.3),
    ),
    Dish(
      'Burrito',
      'https://www.cucchiaio.it/content/cucchiaio/it/ricette/2018/03/burrito-di-carne/jcr:content/header-par/image-single.img10.jpg/1521454018401.jpg',
      Price('€', 9.99),
      ReviewScore(3.9),
    ),
    Dish(
      'Fajitas',
      'https://www.isabeleats.com/wp-content/uploads/2018/04/easy-steak-fajitas-small-1.jpg',
      Price('€', 13.59),
      ReviewScore(4.0),
    ),
    Dish(
      'Enchiladas con fagioli neri',
      'https://tmbidigitalassetsazure.blob.core.windows.net/secure/RMS/attachments/37/1200x1200/Creamy-Chicken-Enchiladas_EXPS_DIA18_33124_B05_25_2b.jpg',
      Price('€', 15.59),
      ReviewScore(4.9),
    ),
  ]),
  MenuSection('Second dishes', <Dish>[
    Dish(
      'Carne con chile',
      'https://www.sbs.com.au/food/sites/sbs.com.au.food/files/latin-kitchen_1014_chile-verde-con-carne-y-papas.jpg',
      Price('€', 12.59),
      ReviewScore(3.5),
    ),
    Dish(
      'Costillas Monterrey',
      'https://media-cdn.tripadvisor.com/media/photo-s/10/07/5e/fd/esto-es-soulfood-costillas.jpg',
      Price('€', 10.59),
      ReviewScore(4.8),
    ),
  ]),
]);
