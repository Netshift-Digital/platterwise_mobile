import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/restaurant_service.dart';
import 'package:platterwave/model/restaurant/banner_model.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/random_functions.dart';

class RestaurantViewModel extends BaseViewModel{
  RestaurantService restaurantService = locator<RestaurantService>();
  List<RestaurantData> allRestDetail = [];
  List<AllBannersList> allBannersList = [];

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
      var data = await restaurantService.makeReservation(reservationData);
      if(data!=null){
       return true;
      }
    }catch(e){
      RandomFunction.toast('Something went wrong');
    }
    return false;
  }

}