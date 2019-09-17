import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:prova/models/reservation.dart';

class ReserveApi {
  // static final baseUrl = 'demo4024441.mockable.io';
  static final baseUrl = 'default-lb-519596853.eu-west-2.elb.amazonaws.com';

  static getRestaurantReservations(String restId) {
    final String path = '/reservation/restaurant';
    var params = { 'restId': restId };
    var url = Uri.http(baseUrl, path, params);

    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };
    return get(url, headers: headers);
  }

  static getMyReservations(String userId) {
    final String path = '/reservation/user';
    var params = { 'userId': userId };
    var url = Uri.http(baseUrl, path, params);

    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };
    return get(url, headers: headers);
  }

  static makeReservation(Reservation reservation) {
    // final String path = '/reservation';
    final String path = '/reservation-service/reservationDemo';
    var url = Uri.http(baseUrl, path);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String body = jsonEncode(reservation);
    print(body);
    return post(url, headers: headers, body: body,);
  }
}