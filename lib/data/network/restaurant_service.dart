import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/utils/random_functions.dart';

class RestaurantService{
  var client = http.Client();


  Future<Map<String, dynamic>?> getRestaurantList() async {
    var body = jsonEncode({
        "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
        "get_all_resturant":"get_all_resturant"

    });
    try {
      var response =
      await client.get(Uri.parse("${baseurl2}get_all_details.php"),
          //body: body,
          headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }




  Future<Map<String, dynamic>?> getRestaurantReviews(String resId) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      "rest_id":resId

    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}get_restaurant_review.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }



  Future<Map<String, dynamic>?> addReview({
    required String resId,
    required String review,
    required String rate}) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      "rate":rate,
      "review":review,
      "rest_id":resId
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}rate_restaurant.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }



  Future<Map<String, dynamic>?> getBanner() async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}get_banner.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }



  Future<Map<String, dynamic>?> makeReservation(ReservationData reservationData) async {
    var body = jsonEncode(reservationData.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}make_reservation.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      //RandomFunction.toast(data['status']);
      if(response.statusCode==200){
        return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }
}