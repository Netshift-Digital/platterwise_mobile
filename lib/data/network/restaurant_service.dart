import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/split_bill_model.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/split_bill.dart';

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
      FirebaseFirestore.instance.collection('reviews')
      .doc(resId).set({
        'date':DateTime.now().millisecondsSinceEpoch.toString()
      });
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


  Future<Map<String, dynamic>?> getReservation() async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}user_all_reserv.php"),
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
      RandomFunction.toast(data['status']);
      if(response.statusCode==200){
        FirebaseFirestore.instance.collection('reservations').doc(reservationData.restId)
        .set({"name":reservationData.reservationDate});
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


  Future<Map<String, dynamic>?> cancelReservation(String id) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      'reserv_id':id
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}cancel_reservationt.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['status']);
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



  Future<Map<String, dynamic>?> getBill(String id) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      'reserv_id':id
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}get_bill.php"),
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



  Future<Map<String, dynamic>?> singleReservation(String id) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      'reserv_id':id
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}user_single_reserv.php"),
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




  Future<Map<String, dynamic>?> searchRestaurant(String search) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      'search':search.trim()
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}search_restaurant.php"),
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


  Future<Map<String, dynamic>?> splitBill(SplitBillModel splitBillModel) async {
    var body = jsonEncode(splitBillModel.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}split_bill.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
     var data = jsonDecode(response.body.replaceAll("Message sent!Message sent!", ""));
      RandomFunction.toast(data['status']);
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



  Future<Map<String, dynamic>?> getPaidGuest(String id) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      'reserv_id':id
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl2}get_paid_guests.php"),
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