import 'dart:io';
// import 'dart:convert';

import 'package:http/http.dart';

class NearmeApi {
  // static final baseUrl = 'demo4024441.mockable.io';
  static final baseUrl = 'default-lb-519596853.eu-west-2.elb.amazonaws.com';

  static nearmeRestaurants() {
    // final String path = '/nearme';
    final String path = '/restaurant-catalog-service/nearme';
    var url = Uri.http(baseUrl, path);

    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };
    return get(url, headers: headers,);
  }
}