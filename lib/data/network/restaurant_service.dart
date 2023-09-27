import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/split_bill_model.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/utils/random_functions.dart';

class RestaurantService {
  var client = http.Client();

  Future<Map<String, dynamic>?> getRestaurantList() async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "get_all_resturant": "get_all_resturant"
    });
    try {
      var response =
          await client.get(Uri.parse("${baseurl2}get_all_details.php"),
              //body: body,
              headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> getTopRated() async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
    });
    print("This is the id ${FirebaseAuth.instance.currentUser!.uid}");
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}top_ratedRest.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> getResturantById(int id) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "rest_id": id,
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}getRestaurant_byId.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
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

  Future<Map<String, dynamic>?> getByState(String state) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "state": state
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}search_by_state.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> nearBy(LatLong latLong) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "latitude": latLong.latitude,
      "longitude": latLong.longitude
    });
    try {
      var response = await client.post(
          Uri.parse("https://api.platterwise.com/jhome2/closest_rest.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      print(response.statusCode);
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return data;
      } else {
        RandomFunction.toast(data['status']);
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      print(e);
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getRestaurantReviews(String resId) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "rest_id": resId
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}get_restaurant_review.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> addReview(
      {required String resId,
      required String review,
      required String rate}) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "rate": rate,
      "review": review,
      "rest_id": resId
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}rate_restaurant.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      FirebaseFirestore.instance
          .collection('reviews')
          .doc(resId)
          .set({'date': DateTime.now().millisecondsSinceEpoch.toString()});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl2}get_banner.php"), body: body, headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}user_all_reserv.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> makeReservation(
      ReservationData reservationData) async {
    var map = reservationData.toJson();
    // map.putIfAbsent('subject_of_invite', () => '');
    var body = jsonEncode(map);
    //print(body);
    try {
      var response = await client.post(
          Uri.parse(
            "${baseurl2}make_reservation.php",
          ),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body.replaceAll('Message sent!', ''));
      if (response.statusCode == 200) {
        RandomFunction.toast('Success');
        FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationData.restId)
            .set({"name": reservationData.reservationDate});
        return data;
      } else {
        RandomFunction.toast('Something went wrong');
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      print(e);
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }

  Future<Map<String, dynamic>?> cancelReservation(String id) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'reserv_id': id
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}cancel_reservationt.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['status']);
      print("After cancelling reservation i get $data");
      if (response.statusCode == 200) {
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
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'reserv_id': id
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl2}get_bill.php"), body: body, headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<String?> getTransactionID(String id, num bill) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'reserv_id': id,
      "owner_bill": bill.toString()
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl2}single_bill.php"), body: body, headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return data['transactionId'];
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
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'reserv_id': id
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}user_single_reserv.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      //RandomFunction.toast(data['status']);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> searchRestaurant(
      String search, LatLong latLong) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'search': search.trim(),
      "latitude": latLong.latitude,
      "longitude": latLong.longitude
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}search_restaurant.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
    print(body);
    try {
      var response = await client.post(
        Uri.parse("${baseurl2}split_bill.php"),
        body: body,
        headers: {
          "Content-type": "application/json",
        },
      ).timeout(const Duration(seconds: 10));
      var data = jsonDecode(
          response.body.replaceAll("Message sent!Message sent!", ""));
      if (response.statusCode == 200) {
        RandomFunction.toast('Success');
        return data;
      } else {
        RandomFunction.toast('Something went wrong');
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
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'reserv_id': id
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}get_paid_guests.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      //RandomFunction.toast(data['status']);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> favouriteRestaurant(String id) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'rest_id': id
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl2}saved_rest.php"), body: body, headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print("This is the result unfav $data");
      RandomFunction.toast(data['status']);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> unfavouriteRestaurant(String id) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'rest_id': id
    });
    print("The body is $body");
    try {
      var response = await client
          .post(Uri.parse("${baseurl2}unsaved_rest.php"), body: body, headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print("This is the result unfav $data");
      RandomFunction.toast(data['status']);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> getFavouriteRestaurant() async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}get_saved_rest.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> followRestaurant(String id) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'rest_id': id
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl2}follow_rest.php"), body: body, headers: {
        "Content-type": "application/json",
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['status']);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> unfollowRestaurant(String id) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      'rest_id': id
    });
    print("The body is $body");
    try {
      var response = await client.post(
          Uri.parse("${baseurl2}unfollow_rest.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['status']);
      if (response.statusCode == 200) {
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
