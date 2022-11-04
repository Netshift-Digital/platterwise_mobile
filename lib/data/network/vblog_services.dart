import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/post_data.dart';
import 'package:platterwave/utils/random_functions.dart';


class VBlogService{
  var client = http.Client();



  Future<dynamic> getPost() async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl}get_all_post.php"),
          body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }

  Future<dynamic> getUserPost(String id) async {
    var body = jsonEncode({
      "firebaseAuthID":id
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl}get_post.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }


  Future<dynamic> getComment(int postId) async {
    var body = jsonEncode({
      "firebaseAuthID":FirebaseAuth.instance.currentUser!.uid,
      "post_id":postId
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl}get_comment.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }



  Future<dynamic> createPost(PostData postData) async {
    var body = jsonEncode(postData.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl}create_post.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }




  Future<dynamic> commentPost(PostData postData) async {
    var body = jsonEncode(postData.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl}post_comment.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }



  Future<dynamic> likePost(int postId, String uid) async {
    var body = jsonEncode(
        {
          "user_id":uid,
          "post_id":postId

        }
    );
    try {
      var response =
      await client.post(Uri.parse("${baseurl}like.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        //RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }


  Future<dynamic> commentToPost(int postId, String uid,String comment) async {
    var body = jsonEncode(
        {
          "user_id":uid,
          "post_id":postId,
          "comment_post":comment
        }
    );
    try {
      var response =
      await client.post(Uri.parse("${baseurl}post_comment.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }

  Future<dynamic> fellowUser(String uId) async {
    var body = jsonEncode({
      "follower_AuthID":FirebaseAuth.instance.currentUser!.uid,
      "followed_AuthID":uId
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl}follow_user.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        //RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }


  Future<dynamic> unFellowUser(String uId) async {
    var body = jsonEncode({
      "follower_AuthID":FirebaseAuth.instance.currentUser!.uid,
      "followed_AuthID":uId
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl}unfollow_user.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        //RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }



  Future<dynamic> searchUser(String search) async {
    var body = jsonEncode({
      "search_post":search,
    });
    try {
      var response =
      await client.post(Uri.parse("${baseurl}search_post.php"),
          body: body, headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }else{
        //RandomFunction.toast(data['status']??"");
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }
}