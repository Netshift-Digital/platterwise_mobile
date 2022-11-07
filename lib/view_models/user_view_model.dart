import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/random_functions.dart';

class UserViewModel extends BaseViewModel{
  UserService userService = locator<UserService>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  UserData? user;

  Future<bool> registerUser(RegisterModel registerModel,String imagePath)async{
    try{
      setState(AppState.busy);
      //var image = await uploadImage(imagePath);
      var user = await firebaseAuth.createUserWithEmailAndPassword(
          email: registerModel.email,
          password: registerModel.password);
     var reg =   registerModel.copyWith(
         authId: user.user!.uid
     );
      var data = await userService.signUp(reg);

      setState(AppState.idle);
      if(data!=null){
        return data["status"].toString().toLowerCase().contains("success");
      }
    }on FirebaseAuthException catch(e){
      setState(AppState.idle);
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
      setState(AppState.idle);
      return data.user;
    }on FirebaseAuthException catch(e){
      setState(AppState.idle);
      if (kDebugMode) {
        print(e);
      }
    }
    return null;




  }

  Future<bool> changePassword(String newPassword,String currentPassword)async{
    final user =  FirebaseAuth.instance.currentUser!;
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

  Future<bool?> editUser(EditData editData)async{
    try{
      setState(AppState.busy);
      var data = await userService.editProfile(editData);
      setState(AppState.idle);
      if(data!=null){
        return true;
      }
    }catch(e){
      RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  Future<UserData?> getMyProfile()async{
    try{
      var data = await userService.getUser(FirebaseAuth.instance.currentUser!.uid);
      if(data!=null){
        var userData = UserData.fromJson(data);
        user = UserData(status: userData.status,
            userProfile: userData.userProfile.copyWith(
              firebaseAuthID:FirebaseAuth.instance.currentUser!.uid
            )
        );
        notifyListeners();
        return user;
      }
      setState(AppState.idle);
    }catch(e){
      RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }

  Future<UserData?> getUserProfile(String uid)async{
    try{
      var data = await userService.getUser(uid);
      if(data!=null){
        var user = UserData.fromJson(data);
       return UserData(status: user.status,
           userProfile: user.userProfile.copyWith(
             firebaseAuthID: uid
           ));
      }
      setState(AppState.idle);
    }catch(e){
      RandomFunction.toast("something went wrong");
      setState(AppState.idle);
    }
    return null;
  }



}