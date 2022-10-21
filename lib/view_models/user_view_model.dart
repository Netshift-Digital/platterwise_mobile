import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';

class UserViewModel extends BaseViewModel{
  UserService userService = locator<UserService>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<bool> registerUser(RegisterModel registerModel,String imagePath)async{
    try{
      setState(AppState.busy);
      //var image = await uploadImage(imagePath);
      var user = await firebaseAuth.createUserWithEmailAndPassword(
          email: registerModel.email,
          password: registerModel.password);

      var data = await userService.signUp(
          registerModel.copyWith(
         authId: user.user!.uid
      ));
      setState(AppState.idle);
      if(data!=null){
        return data["status"].toString().toLowerCase().contains("success");
      }
    }on FirebaseAuthException catch(e){
      if (kDebugMode) {
        print(e.code);
      }
    } catch(e){
      setState(AppState.idle);
    }


    return false;
  }


  Future<String?> uploadImage(String filePath,{String username="platerwise"})async{
   try{
     File file = File(filePath);
     var data = await firebaseStorage.ref("profile").child(username).putData(file.readAsBytesSync());
     var url = await data.ref.getDownloadURL();
     return url;
   }on FirebaseException catch (e){
     setState(AppState.idle);
   }
    return null;
  }



  Future<User?> login(String email, String password)async{
    try{
      setState(AppState.busy);
      var data = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return data.user;
    }on FirebaseAuthException catch(e){
      setState(AppState.idle);
      if (kDebugMode) {
        print(e);
      }
    }
    return null;




  }
}