import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/restaurant_service.dart';
import 'package:platterwave/model/request_model/split_bill_model.dart';
import 'package:platterwave/model/restaurant/banner_model.dart';
import 'package:platterwave/model/restaurant/paid_guest.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/model/restaurant/search_restaurant_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/location_view_model.dart';

class RestaurantViewModel extends BaseViewModel {
  RestaurantService restaurantService = locator<RestaurantService>();
  List<RestaurantData> allRestDetail = [];
  List<RestaurantData> favouriteRestaurant = [];
  List<RestaurantData> followedRestaurant = [];
  List<RestaurantData> topRestaurant = [];
  List<RestaurantData> nearByRestaurant = [];
  List<RestaurantData> closeByRestaurant = [];
  List<BannerDetail> allBannersList = [];
  List<UserReservation> userReservation = [];
  //List<RestaurantData> followedRestaurants = [];

  String _state = "lagos";
  LatLong latLong = LatLong(6.5243793, 3.3792057);
  String get state => _state;
  AppState reviewState = AppState.idle;

  setLocationState(LocationData locationData) async {
    _state = locationData.state;
    latLong = locationData.latLong;
    await closeBy();
    //await getByState();
  }

  bool isFavourite(String id) {
    return favouriteRestaurant
        .any((element) => element.restId.toString() == id);
  }

  bool isFollowed(String id) {
    return followedRestaurant.any((element) => element.restId.toString() == id);
  }

  setReviewState(AppState state) {
    reviewState = state;
    notifyListeners();
  }

  Future<List<RestaurantData>> getRestaurant() async {
    try {
      var data = await restaurantService.getRestaurantList();
      if (data != null) {
        allRestDetail = [];
        allRestDetail = Restaurant.fromJson(data).allRestDetail;
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return allRestDetail;
  }

  Future<List<RestaurantData>> closeBy() async {
    try {
      var data = await restaurantService.nearBy(latLong);
      if (data != null) {
        closeByRestaurant = [];
        closeByRestaurant = SearchRestaurantModel.fromJson(data).searchResult;
        notifyListeners();
      } else {
        closeByRestaurant = [];
        notifyListeners();
      }
    } catch (e) {
      print(e);
      //
    }
    return closeByRestaurant;
  }

  Future<void> followRestaurant(RestaurantData restaurantData) async {
    try {
      if (!isFollowed(restaurantData.restId.toString())) {
        followedRestaurant.add(restaurantData);
        notifyListeners();
        await restaurantService
            .followRestaurant(restaurantData.restId.toString());
      } else {
        followedRestaurant.removeWhere(
            (r) => r.restId.toString() == restaurantData.restId.toString());
        notifyListeners();
        await restaurantService
            .unfollowRestaurant(restaurantData.restId.toString());
      }
    } catch (e) {
      //
    }
  }

  Future<List<RestaurantData>> getTopRestaurant() async {
    try {
      var data = await restaurantService.getTopRated();
      if (data != null) {
        topRestaurant = [];
        topRestaurant = Restaurant.fromJson(data).allRestDetail;
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return topRestaurant;
  }

  Future<RestaurantData?> getRestaurantById(int id) async {
    try {
      var data = await restaurantService.getResturantById(id);
      if (data != null) {
        return RestaurantData.fromJson(data['data']);
      }
    } catch (e) {
      //
    }
    return null;
  }

  Future<List<RestaurantData>> getByState() async {
    try {
      var data = await restaurantService.getByState(state);
      if (data != null) {
        var list = SearchRestaurantModel.fromJson(data).searchResult;
        nearByRestaurant = list;
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return nearByRestaurant;
  }

  Future<List<RestaurantData>> searchRestaurant(String text) async {
    try {
      var data = await restaurantService.searchRestaurant(text, latLong);
      if (data != null) {
        var list = List<RestaurantData>.from(
            data["data"].map((x) => RestaurantData.fromJson(x)));
        return list;
      }
    } catch (e) {
      RandomFunction.toast("Something went wrong");
      print(e.toString());
    }
    return [];
  }

  Future<List<UserReservation>> getReservations() async {
    try {
      var data = await restaurantService.getReservation();
      if (data != null) {
        userReservation = List<UserReservation>.from(
            data["data"].map((x) => UserReservation.fromJson(x)));
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
    return userReservation;
  }

/*
  Future<List<AllRestReview>> getReview(String resId) async {
    try {
      var data = await restaurantService.getRestaurantReviews(resId);
      setReviewState(AppState.idle);
      if (data != null) {
        return RestaurantReview.fromJson(data).allRestReview;
      }
    } catch (e) {
      //
    }
    return [];
  }*/

  Future<RestaurantData?> addReview(
      {required String resId,
      required String review,
      required String rate}) async {
    try {
      setReviewState(AppState.busy);
      var data = await restaurantService.addReview(
          resId: resId, review: review, rate: rate);
      if (data != null) {
        final resc = await getRestaurantById(int.parse(resId));
        return resc;
      }
    } catch (e) {
      setReviewState(AppState.idle);
    }
    return null;
  }

  Future<List<BannerDetail>> getBanner() async {
    try {
      var data = await restaurantService.getBanner();
      if (data != null) {
        allBannersList = List<BannerDetail>.from(
            data["data"].map((x) => BannerDetail.fromJson(x)));
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return allBannersList;
  }

  Future<bool> makeReservation(ReservationData reservationData) async {
    try {
      setState(AppState.busy);
      var data = await restaurantService.makeReservation(reservationData);
      setState(AppState.idle);
      if (data != null) {
        getReservations();
        return true;
      }
    } catch (e) {
      print("Error with making reservation ${e.toString()}");
      setState(AppState.idle);
      //   RandomFunction.toast('Something went wrong.');
    }
    return false;
  }

  Future<bool> cancelReservation(String id) async {
    try {
      setState(AppState.busy);
      print("Reservation Id is $id");
      var data = await restaurantService.cancelReservation(id);
      setState(AppState.idle);
      getReservations();
      if (data != null) {
        return true;
      }
    } catch (e) {
      setState(AppState.idle);
      RandomFunction.toast('Something went wrong');
    }
    return false;
  }

  Future<SingleTransactionId?> getTransactionID(UserReservation id) async {
    try {
      setState(AppState.busy);
      var data = await restaurantService.getTransactionID(id);
      if (data != null) {
        return SingleTransactionId.fromJson(data["data"]);
      }
      setState(AppState.idle);
    } catch (e) {
      setState(AppState.idle);
      RandomFunction.toast('Something went wrong');
    }
    return null;
  }

  Future<UserReservation?> getSingleReservation(String id) async {
    try {
      var data = await restaurantService.singleReservation(id);
      setState(AppState.idle);
      if (data != null) {
        return UserReservation.fromJson(data['data']);
      }
    } catch (e) {
      setState(AppState.idle);
      print(e.toString());
      RandomFunction.toast('Something went wrong');
    }
    return null;
  }

  Future<bool> splitBill(SplitBillModel splitBillModel) async {
    try {
      setState(AppState.busy);
      var data = await restaurantService.splitBill(splitBillModel);
      setState(AppState.idle);
      if (data != null) {
        return data["success"];
      }
    } catch (e) {
      setState(AppState.idle);
      // RandomFunction.toast('Something went wrong');
    }
    return false;
  }

  Future<List<AllPaidList>> getPaidGuest(String id) async {
    try {
      var data = await restaurantService.getPaidGuest(id);
      setState(AppState.idle);
      if (data != null) {
        final res = List<AllPaidList>.from(
            data["data"].map((x) => AllPaidList.fromJson(x)));

        print(res.length);
        return res;
      }
    } catch (e) {
      setState(AppState.idle);
      print(e.toString());
      RandomFunction.toast('Something went wrong');
    }
    return [];
  }

  Future<void> saveRestaurant(RestaurantData restaurantData) async {
    try {
      if (!isFavourite(restaurantData.restId.toString())) {
        favouriteRestaurant.add(restaurantData);
        notifyListeners();
        await restaurantService
            .favouriteRestaurant(restaurantData.restId.toString());
      } else {
        await restaurantService
            .unfavouriteRestaurant(restaurantData.restId.toString());
        favouriteRestaurant.removeWhere(
            (r) => r.restId.toString() == restaurantData.restId.toString());
        notifyListeners();
      }
    } catch (e) {
      //
    }
  }

  Future<List<RestaurantData>> getFavouriteRestaurant() async {
    try {
      var data = await restaurantService.getFavouriteRestaurant();
      if (data != null) {
        favouriteRestaurant = [];
        for (var e in data['data']) {
          favouriteRestaurant.add(RestaurantData.fromJson(e['restaurant'][0]));
        }
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return favouriteRestaurant;
  }

  Future<List<RestaurantData>> getFollowedRestaurant() async {
    try {
      var data = await restaurantService.getFollowedRestaurant();
      if (data != null) {
        followedRestaurant = [];
        for (var e in data['data']) {
          print("A single e is $e");
          followedRestaurant.add(RestaurantData.fromJson(e['restaurant']));
        }
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return favouriteRestaurant;
  }
}
