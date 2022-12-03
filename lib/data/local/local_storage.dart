import 'package:hive/hive.dart';
import 'package:platterwave/constant/keys.dart';
import 'package:platterwave/model/profile/user_data.dart';

class LocalStorage{

  var box = Hive.box("post");

   savePost(Map data){
    box.add(data);
   }


  static saveUser(Map data){
    Hive.box(authKey).put(authKey, data);

  }


  static UserData? getUser(){
  var data = Hive.box(authKey).get(authKey);
  if(data!=null){
   return UserData.fromJson(data);
  }
  return null;

  }

 static void clear(){
    Hive.box(authKey).clear();
  }



  List<dynamic> getPost(){
  return  box.values.toList();
  }
}