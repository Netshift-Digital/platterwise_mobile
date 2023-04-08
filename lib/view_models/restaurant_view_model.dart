import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/restaurant_service.dart';
import 'package:platterwave/model/restaurant/banner_model.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/random_functions.dart';

class RestaurantViewModel extends BaseViewModel{
  RestaurantService restaurantService = locator<RestaurantService>();
  List<RestaurantData> allRestDetail = [];
  List<AllBannersList> allBannersList = [];
  List<UserReservation> userReservation = [];

  Future<List<RestaurantData>> getRestaurant() async{
    try{
      var data = await restaurantService.getRestaurantList();
      if(data!=null){
        allRestDetail = Restaurant.fromJson(data).allRestDetail;
        notifyListeners();
      }
    }catch(e){
      //
    }
    return allRestDetail;
  }

  Future<List<UserReservation>> getReservations() async{
    try{
      var data = await restaurantService.getReservation();
      if(data!=null){
        userReservation = ReservationList.fromJson(data).userReservation;
        notifyListeners();
      }
    }catch(e){
      //
    }
    return userReservation;
  }

  Future<List<AllRestReview>> getReview(String resId) async{
    try{
      var data = await restaurantService.getRestaurantReviews(resId);
      if(data!=null){
        return RestaurantReview.fromJson(data).allRestReview;
      }
    }catch(e){
      //
    }
    return [];
  }


  Future<List<AllRestReview>> addReview({
    required String resId,
    required String review,
    required String rate}) async{
    try{
      var data = await restaurantService.addReview(resId: resId, review: review, rate: rate);
      if(data!=null){
        return getReview(resId);
      }
    }catch(e){
      //
    }
    return [];
  }


  Future<List<AllBannersList>> getBanner() async{
    try{
      var data = await restaurantService.getBanner();
      if(data!=null){
        allBannersList = Banner.fromJson(data).allBannersList;
        notifyListeners();
      }
    }catch(e){
      //
    }
    return allBannersList;
  }


  Future<bool> makeReservation(ReservationData reservationData) async{
    try{
      setState(AppState.busy);
      var data = await restaurantService.makeReservation(reservationData);
      setState(AppState.idle);
      getReservations();
      if(data!=null){
       return true;
      }
    }catch(e){
      setState(AppState.idle);
      RandomFunction.toast('Something went wrong');
    }
    return false;
  }

  Future<bool> cancelReservation(String id) async{
    try{
      setState(AppState.busy);
      var data = await restaurantService.cancelReservation(id);
      setState(AppState.idle);
      getReservations();
      if(data!=null){
        return true;
      }
    }catch(e){
      setState(AppState.idle);
      RandomFunction.toast('Something went wrong');
    }
    return false;
  }

  Future<ReservationBillElement?> getReservationBill(String id) async{
    try{
      setState(AppState.busy);
      var data = await restaurantService.getBill(id);
      setState(AppState.idle);
      if(data!=null){
        return ReservationBill.fromJson(testData).reservationBill.first;
      }
    }catch(e){
      setState(AppState.idle);
     // RandomFunction.toast('Something went wrong');
    }
    return null;
  }

  Future<UserReservation?> getSingleReservation(String id) async{
    try{
      var data = await restaurantService.singleReservation(id);
      setState(AppState.idle);
      if(data!=null){
        return ReservationList.fromJson(data).userReservation.first;
      }
    }catch(e){
      setState(AppState.idle);
      //RandomFunction.toast('Something went wrong');
    }
    return null;
  }

}