import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/auth_medthod.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/random_functions.dart';

class UserViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
    } on FirebaseAuthException catch (e) {
      setState(AppState.idle);
      RandomFunction.toast(e.code);
      if (kDebugMode) {
        print(e.code);
        error = e.code;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      setState(AppState.idle);
    }
    return false;
  }

  Future<AuthMethod?> google() async {
    try {
      setState(AppState.busy);
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        setState(AppState.idle);
        //  if (userCredential.user != null) {
        //  return await checkUser(userCredential);
        // }
      } else {
        setState(AppState.idle);
      }
    } on FirebaseAuthException catch (e) {
      setState(AppState.idle);
    } catch (e) {
      //
    }
  }

/*
  Future<AuthMethod?> checkUser(UserCredential userCredential) async {
    try {
      setState(AppState.busy);
      var data = await getUserProfile();
      setState(AppState.idle);
      if (data == null) {
        return AuthMethod(newUser: true, user: userCredential.user);
      } else {
        return AuthMethod(newUser: false, user: userCredential.user);
      }
    } catch (e) {
      setState(AppState.idle);
      //
    }
    return null;
  }*/

  Future<AuthMethod?> signInWithFacebook() async {
    // final LoginResult loginResult = await FacebookAuth.instance.login();
    // if (loginResult.status == LoginStatus.success) {
    //   final AccessToken accessToken = loginResult.accessToken!;
    //   //final userData = await FacebookAuth.instance.getUserData();
    //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
    //   final UserCredential userCredential = await
    //   FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    //   if(userCredential.user!=null){
    //     return checkUser(userCredential);
    //   }
    // } else {
    //   setState(AppState.idle);
    //   return null;
    // }
    // return null;
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

  Future<bool> changePassword(
      String newPassword, String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    setState(AppState.busy);
    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        setState(AppState.idle);
        RandomFunction.toast("Password updated");
        return true;
      }).catchError((error) {
        setState(AppState.idle);
        RandomFunction.toast(error.toString());
        return false;
      });
    }).catchError((err) {
      setState(AppState.idle);
      RandomFunction.toast(err.toString());
    });
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
      var data = await userService.getMyProfile();
      if (data != null) {
        var user = UserProfile.fromJson(data);
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
