import 'package:hive/hive.dart';
import 'package:platterwave/constant/keys.dart';
import 'package:platterwave/model/profile/user_data.dart';

class LocalStorage {
  var box = Hive.box("post");

  savePost(Map data) {
    box.add(data);
  }

  static saveToken(String newToken) {
    Hive.box(token).put("token", newToken);
  }

  static String getToken() {
    return Hive.box(token).get("token", defaultValue: "");
  }

  static saveLoginTime() {
    DateTime loginTime = DateTime.now();
    String loginTimeString = loginTime.toIso8601String();
    Hive.box(token).put("time", loginTimeString);
  }

  static String getLoginTime() {
    return Hive.box(token).get("time", defaultValue: "");
  }

  static bool isFirstTime() {
    return Hive.box(authKey).get("isFirstTime", defaultValue: true);
  }

  static changeIsFirstTime(bool status) {
    Hive.box(authKey).put("isFirstTime", status);
  }

  static saveUser(Map data) {
    Hive.box(authKey).put(authKey, data);
  }

  static UserData? getUser() {
    var data = Hive.box(authKey).get(authKey);
    if (data != null) {
      return UserData.fromJson(data);
    }
    return null;
  }

  static void clear() {
    Hive.box(authKey).clear();
  }

  List<dynamic> getPost() {
    return box.values.toList();
  }
}
