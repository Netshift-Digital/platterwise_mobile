import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/random_functions.dart';

class UserViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  UserProfile? user;
  String error = "";

  Future<bool> registerUser(
      RegisterModel registerModel, String imagePath) async {
    try {
      setState(AppState.busy);
      var data = await userService.signUp(registerModel);
      setState(AppState.idle);
      if (data != null) {
        return data["success"];
      }
    } catch (e) {
      print(e);
      setState(AppState.idle);
    }
    return false;
  }

  Future<String?> uploadImage(String filePath,
      {String username = "platerwise"}) async {
    try {
      File file = File(filePath);
      var d = "${DateTime.now().microsecondsSinceEpoch}.png";
      var data =
          await firebaseStorage.ref().child(d).putData(file.readAsBytesSync());
      var url = await data.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e.toString());
      setState(AppState.idle);
    }
    return null;
  }

  Future<bool?> login(String email, String password) async {
    try {
      setState(AppState.busy);
      var res = await userService.signIn(email, password);
      setState(AppState.idle);
      return res["status"];
    } catch (e) {
      print(e.toString());
      setState(AppState.idle);
    }
    return null;
  }

  Future<bool> validateEmail(String email) async {
    try {
      setState(AppState.busy);
      var res = await userService.validateEmail(email);
      setState(AppState.idle);
      if (res != null) {
        return true;
      }
    } catch (e) {
      print(e.toString());
      setState(AppState.idle);
    }
    return false;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      setState(AppState.busy);
      var res = await userService.changePassword(oldPassword, newPassword);
      setState(AppState.idle);
      if (res != null) {
        return true;
      }
    } catch (e) {
      print(e.toString());
      setState(AppState.idle);
    }
    return false;
  }

  Future<bool> resetPassword(
      String email, String password, String token) async {
    try {
      setState(AppState.busy);
      var res = await userService.resetPassword(email, password, token);
      setState(AppState.idle);
      if (res != null) {
        return true;
      }
    } catch (e) {
      print(e.toString());
      setState(AppState.idle);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      setState(AppState.busy);
      var res = await userService.logout();
      setState(AppState.idle);
      if (res != null) {
        return true;
      }
    } catch (e) {
      print("The error is ${e.toString()}");
      setState(AppState.idle);
    }
    return false;
  }

  Future<bool?> editUser(EditData editData) async {
    try {
      setState(AppState.busy);
      var data = await userService.editProfile(editData);
      setState(AppState.idle);
      if (data != null) {
        //   getMyProfile();
        return data["success"];
      }
    } catch (e) {
      RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  Future<UserProfile?> getMyProfile() async {
    try {
      var data = await userService.getMyProfile();
      if (data != null) {
        var userInfo = UserProfile.fromJson(data["profile"]);
        LocalStorage.saveUser(userInfo.toJson());
        user = userInfo;
        notifyListeners();
        return user;
      }
      setState(AppState.idle);
    } catch (e) {
      RandomFunction.toast("something went wrong");
      print(e.toString());
      setState(AppState.idle);
    }
    return null;
  }

//This can be for getting another user profile
  Future<UserProfile?> getUserProfile(String id) async {
    try {
      var data = await userService.getOtherUserProfile(id);
      if (data != null) {
        var user = UserProfile.fromJson(data["profile"]);
        return user;
      }
      setState(AppState.idle);
    } catch (e) {
      RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }
}
