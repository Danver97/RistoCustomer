import 'dart:io';
// import 'dart:convert';

import 'package:http/http.dart';

class NearmeApi {
  static final baseUrl = '';

  static nearmeRestaurants() {
    final String path = '/nearme';
    var url = Uri.http(baseUrl, path);

    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };
    return get(url, headers: headers,);
  }
}