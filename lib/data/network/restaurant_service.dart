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
import 'package:platterwave/model/restaurant/reservation_model.dart';
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
    var token = LocalStorage.getToken();

    try {
      var response = await client
          .get(Uri.parse("${baseurl3}restaurant/top-rated"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 20));
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

  Future<Map<String, dynamic>?> nearBy(LatLong latLong, String state) async {
    var body = {
      "latitude": "${latLong.latitude}",
      "longitude": "${latLong.longitude}",
      "state": state
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

  /* Future<Map<String, dynamic>?> getRestaurantReviews(String resId) async {
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
*/

  Future<Map<String, dynamic>?> addReview(
      {required String resId,
      required String review,
      required String rate}) async {
    var token = LocalStorage.getToken();
    var body = jsonEncode(
        {"star_rating": rate, "comment": review, "restaurant_id": resId});
    print("This is the body for rating $body");
    try {
      var response = await client.post(Uri.parse("${baseurl3}restaurant/rate"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(resId)
          .set({'date': DateTime.now().millisecondsSinceEpoch.toString()}).then(
              (value) => print("It worked"));
      var data = jsonDecode(response.body);
      print("After rating $data");
      if (data["status_code"] == 200 && data["success"] == true) {
        RandomFunction.toast(data['response']);
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

  Future<Map<String, dynamic>?> getBanner() async {
    var token = LocalStorage.getToken();

    try {
      var response = await client.get(Uri.parse("${baseurl3}restaurant/banner"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);
      print("The banner is $data");
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

  Future<Map<String, dynamic>?> getReservation(int page) async {
    var token = LocalStorage.getToken();
    try {
      var response = await client
          .get(Uri.parse("${baseurl3}reservation/all?page=$page"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 10));
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
      print("This is the reser date ${reservationData.reservationDate}");
      if (data['status_code'] == 200 && data['success'] == true) {
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationData.restId)
            .set({"name": reservationData.reservationDate}).then(
                (value) => print("It has finished creating"));
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
      print(e.toString);
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

  Future<Map<String, dynamic>?> getTransactionID(UserReservation res) async {
    var body = jsonEncode({
      "reservation_id": "${res.reservId}",
      "total_amount": "${res.bill?.grandPrice}",
      "guests": [
        {
          "guest_email": "${res.allGuestInfo[0].guestEmail}",
          "bill": "${res.bill?.grandPrice}",
          "type": "owner",
          "guest_name": "${res.allGuestInfo[0].guestName}"
        }
      ]
    });
    print("This is the body $body");
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
        Uri.parse("${baseurl3}reservation/split-bills"),
        body: body,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print("This is the result after getting ref bills $data");
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

  Future<Map<String, dynamic>?> singleReservation(String id) async {
    var token = LocalStorage.getToken();

    try {
      var response = await client
          .get(Uri.parse("${baseurl3}reservation/view/$id"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      print("This is the single reservation $data");
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
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
        Uri.parse("${baseurl3}reservation/split-bills"),
        body: body,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        RandomFunction.toast("Bill has been splitted. Kindly Check your Email");
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

  Future<Map<String, dynamic>?> getPaidGuest(String id) async {
    var body = jsonEncode({'reservation_id': id});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}transactions/reservation"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      print("This is the paid guest $data");
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
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
