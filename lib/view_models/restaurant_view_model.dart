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
  List<RestaurantData> topRestaurant = [];
  List<RestaurantData> nearByRestaurant = [];
  List<RestaurantData> closeByRestaurant = [];
  List<AllBannersList> allBannersList = [];
  List<UserReservation> userReservation = [];

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

  setReviewState(AppState state) {
    reviewState = state;
    notifyListeners();
  }

  Future<List<RestaurantData>> getRestaurant() async {
    try {
      var data = await restaurantService.getRestaurantList();
      if (data != null) {
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
        closeByRestaurant = SearchRestaurantModel.fromJson(data).searchResult;
        notifyListeners();
      } else {
        closeByRestaurant = [];
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return closeByRestaurant;
  }

  Future<List<RestaurantData>> getTopRestaurant() async {
    try {
      var data = await restaurantService.getTopRated();
      if (data != null) {
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
      if (data != null && data['get_restaurantById'][0] != null) {
        return RestaurantData.fromJson(data['get_restaurantById'][0]);
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
        var list = SearchRestaurantModel.fromJson(data).searchResult;
        return list;
      }
    } catch (e) {
      //
    }
    return [];
  }

  Future<List<UserReservation>> getReservations() async {
    try {
      var data = await restaurantService.getReservation();
      if (data != null) {
        userReservation = ReservationList.fromJson(data).userReservation;
        notifyListeners();
      }
    } catch (e) {
      //
    }
    return userReservation;
  }

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
  }

  Future<List<AllRestReview>> addReview(
      {required String resId,
      required String review,
      required String rate}) async {
    try {
      setReviewState(AppState.busy);
      var data = await restaurantService.addReview(
          resId: resId, review: review, rate: rate);
      if (data != null) {
        return getReview(resId);
      }
    } catch (e) {
      setReviewState(AppState.idle);
      //
    }
    return [];
  }

  Future<List<AllBannersList>> getBanner() async {
    try {
      var data = await restaurantService.getBanner();
      if (data != null) {
        allBannersList = Banner.fromJson(data).allBannersList;
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

  Future<bool> cancelReservation(String id) async {
    try {
      setState(AppState.busy);
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

  Future<ReservationBill?> getReservationBill(String id) async {
    try {
      setState(AppState.busy);
      var data = await restaurantService.getBill(id);
      setState(AppState.idle);
      if (data != null) {
        var bill = ReservationBillElement.fromJson(data).reservationBill?.first;
        if (bill?.grandPrice != null) {
          return bill;
        }
      }
    } catch (e) {
      setState(AppState.idle);
      // RandomFunction.toast('Something went wrong');
    }
    return null;
  }

  Future<String?> getTransactionID(String id, num bill) async {
    try {
      setState(AppState.busy);
      var data = await restaurantService.getTransactionID(id, bill);
      setState(AppState.idle);
      return data;
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
        return ReservationList.fromJson(data).userReservation.first;
      }
    } catch (e) {
      setState(AppState.idle);
      //RandomFunction.toast('Something went wrong');
    }
    return null;
  }

  Future<bool> splitBill(SplitBillModel splitBillModel) async {
    try {
      setState(AppState.busy);
      var data = await restaurantService.splitBill(splitBillModel);
      setState(AppState.idle);
      if (data != null) {
        return true;
      }
    } catch (e) {
      setState(AppState.idle);
      RandomFunction.toast('Something went wrong');
    }
    return false;
  }

  Future<List<AllPaidList>> getPaidGuest(String id) async {
    try {
      var data = await restaurantService.getPaidGuest(id);
      setState(AppState.idle);
      if (data != null) {
        return PaidGuest.fromJson(data).allPaidList;
      }
    } catch (e) {
      setState(AppState.idle);
      //RandomFunction.toast('Something went wrong');
    }
    return [];
  }

  Future<void> saveRestaurant(RestaurantData restaurantData) async {
    try {
      if(!isFavourite(restaurantData.restId.toString())){
        favouriteRestaurant.add(restaurantData);
        notifyListeners();
        await restaurantService.favouriteRestaurant(restaurantData.restId);
      }
    } catch (e) {
      //
    }
  }
}
