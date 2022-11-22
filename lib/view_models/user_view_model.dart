import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/auth_medthod.dart';
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
   String error ="";



  Future<bool> registerUser(RegisterModel registerModel,String imagePath)async{
    try{
      setState(AppState.busy);
      //var image = await uploadImage(imagePath);
      if(registerModel.authId.isNotEmpty){
        var data = await userService.signUp(registerModel);
        setState(AppState.idle);
        if(data!=null){
          return data["status"].toString().toLowerCase().contains("success");
        }
      }else{
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
      }


    }on FirebaseAuthException catch(e){
      setState(AppState.idle);
      RandomFunction.toast(e.code);
      if (kDebugMode) {
        print(e.code);
        error=e.code;
        notifyListeners();
      }
    } catch(e){
      print(e);
      setState(AppState.idle);
    }


    return false;
  }
  Future<AuthMethod?>google() async{
    try{
      setState(AppState.busy);
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount!=null){
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
        setState(AppState.idle);
        if(userCredential.user!=null){
          setState(AppState.busy);
          var data = await getUserProfile(userCredential.user!.uid);
          setState(AppState.idle);
          if(data==null){
            return AuthMethod(
                newUser:true ,
              user: userCredential.user
            );
          }else{
            return AuthMethod(
                newUser:false ,
                user: userCredential.user
            );
          }
        }
      }

    }on FirebaseAuthException catch (e){
      setState(AppState.idle);
      print(e.code);
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      }
      else if (e.code == 'invalid-credential') {
        // handle the error here
      }
    }
    catch(e){
      //
    }


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
      RandomFunction.toast(e.code);
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