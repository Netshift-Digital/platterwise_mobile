import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/model/request_model/register.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';

class UserViewModel extends BaseViewModel{
  UserService userService = locator<UserService>();

  Future<bool> registerUser(RegisterModel registerModel)async{
    try{
      setState(AppState.busy);
      var data = await userService.signUp(registerModel);
      setState(AppState.idle);
      if(data!=null){
        return data["status"].toString().toLowerCase().contains("success");
      }
    }catch(e){
      setState(AppState.idle);
    }


    return false;
  }
}