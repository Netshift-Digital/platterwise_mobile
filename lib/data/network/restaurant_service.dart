import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:platterwave/data/local/local_storage.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/split_bill_model.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/utils/random_functions.dart';

class RestaurantService {
  var client = http.Client();

  Future<Map<String, dynamic>?> getRestaurantList() async {
    var token = LocalStorage.getToken();

    try {
      var response = await client.get(Uri.parse("${baseurl3}restaurant/index"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data['data'];
      } else {
        RandomFunction.toast(data['response']);
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
    var body = {
      "restaurant_id": "$id",
    };
    var token = LocalStorage.getToken();
    try {
      var response = await client.post(Uri.parse("${baseurl3}restaurant/view"),
          body: jsonEncode(body),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);
      print("This is the single data $data");
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

  Future<Map<String, dynamic>?> getByState(String state) async {
    var body = jsonEncode({"state": state});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}restaurant/state-filter"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (data['status_code'] == 200 && data['success'] == true) {
        return data;
      } else {
        RandomFunction.toast(data["response"]);
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
    var body = {
      "latitude": "${latLong.latitude}",
      "longitude": "${latLong.longitude}"
    };

    var token = LocalStorage.getToken();
    try {
      var response = await client.post(
          Uri.parse("${baseurl3}restaurant/near-you"),
          body: jsonEncode(body),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data;
      } else {
        RandomFunction.toast(data['response']);
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
    print("This is the body $body");

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
    var token = LocalStorage.getToken();
    try {
      var response = await client.get(Uri.parse("${baseurl3}reservation/all"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print("These are all the reservations $data");
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
      } else {
        RandomFunction.toast(data['response']);
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
    print("The body for making reservation is $map");
    var body = jsonEncode(map);
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse(
            "${baseurl3}reservation/create",
          ),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);
      print("The response for make reservation is $data");
      if (data['status_code'] == 200 && data['success'] == true) {
        return data;
      } else {
        RandomFunction.toast(data['response']);
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
    var body = jsonEncode({'reservation_id': id});
    var token = LocalStorage.getToken();
    try {
      var response = await client.post(
          Uri.parse("${baseurl3}reservation/cancel"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print("After cancelling reservation i get $data");
      if (data['status_code'] == 200 && data['success'] == true) {
        return data;
      } else {
        RandomFunction.toast(data['response']);
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
    print("The search query is $search");
    var body = jsonEncode({
      "name": search,
      "latitude": "${latLong.latitude}",
      "longitude": "${latLong.longitude}"
    });
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}restaurant/search-filter"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      print("This is the search data $data");
      if (data["status_code"] == 200 && data["success"] == true) {
        return data;
      } else {
        RandomFunction.toast(data["response"]);
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
    var body = jsonEncode({'restaurant_id': id});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}restaurant/save"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['response']);
      if (data["status_code"] == 200 && data["success"] == true) {
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
    var body = jsonEncode({'restaurant_id': id});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}restaurant/unsave"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['response']);
      if (data["status_code"] == 200 && data["success"] == true) {
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
    var token = LocalStorage.getToken();
    try {
      var response = await client.get(Uri.parse("${baseurl3}restaurant/saved"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
      } else {
        RandomFunction.toast(data['response']);
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

  Future<Map<String, dynamic>?> getFollowedRestaurant() async {
    var token = LocalStorage.getToken();
    try {
      var response = await client
          .get(Uri.parse("${baseurl3}restaurant/followed"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
      } else {
        RandomFunction.toast(data['response']);
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
    var body = jsonEncode({'restaurant_id': id});
    var token = LocalStorage.getToken();
    try {
      var response = await client.post(
          Uri.parse("${baseurl3}restaurant/follow"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['response']);
      if (data["status_code"] == 200 && data["success"] == true) {
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
    var body = jsonEncode({'restaurant_id': id});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}restaurant/unfollow"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['response']);
      if (data["status_code"] == 200 && data["success"] == true) {
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
