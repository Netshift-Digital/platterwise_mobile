import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/post_data.dart';
import 'package:platterwave/utils/random_functions.dart';

class VBlogService {
  var client = http.Client();

  Future<Map<String, dynamic>?> getPost(int pageIndex) async {
    var token = LocalStorage.getToken();
    try {
      var response = await client.get(Uri.parse("${baseurl3}post/all-posts"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
      } else {
        RandomFunction.toast(data["response"]);
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

  Future<dynamic> getLikedPost(String id) async {
    var body = jsonEncode({"firebaseAuthID": id});
    try {
      var response = await client.post(
          Uri.parse("${baseurl}posts_likedbyUser.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        RandomFunction.toast(data['status'] ?? "");
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

  Future<Map<String, dynamic>?> getUserPost(String? id) async {
    String url = "${baseurl3}post/my-posts";
    var token = LocalStorage.getToken();
    try {
      var response = await client.get(Uri.parse(url), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      var data = jsonDecode(response.body);
      print("This are my posts $data");
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
      } else {
        RandomFunction.toast(data["response"]);
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
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "post_id": postId
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl}get_comment.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      // print(data);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> createPost(PostData postData) async {
    var body = jsonEncode(postData.toJson());
    var token = LocalStorage.getToken();

    print("This is the post $body");
    try {
      var response = await client.post(Uri.parse("${baseurl3}post/create"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      print("This is the res for creating post $data");
      if (data["status_code"] == 200 && data["success"] == true) {
        return data;
      } else {
        RandomFunction.toast(data["response"]);
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
    var body = jsonEncode({"firebaseAuthID": uid, "post_id": postId});
    try {
      var response = await client
          .post(Uri.parse("${baseurl}like.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> commentToPost(int postId, String uid, String comment) async {
    var body = jsonEncode(
        {"user_id": uid, "post_id": postId, "comment_post": comment});
    try {
      var response = await client
          .post(Uri.parse("${baseurl}post_comment.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        RandomFunction.toast(data['status'] ?? "");
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

  Future<dynamic> replyToComment(
      int commentId, String uid, String comment) async {
    var body = jsonEncode({
      "firebaseAuthID": uid,
      "comment_id": commentId,
      "reply_post": comment
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl}reply_comment.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        RandomFunction.toast(data['status'] ?? "");
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

  Future<dynamic> getToCommentReply(int commentId) async {
    var body = jsonEncode({
      "comment_id": commentId,
    });
    try {
      var response = await client.post(
          Uri.parse("${baseurl}get_reply_comment.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        RandomFunction.toast(data['status'] ?? "");
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
    var body = jsonEncode({"user": uId});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}user/follow"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        RandomFunction.toast(data['response'] ?? "");
        return data;
      } else {
        RandomFunction.toast(data['response'] ?? "");
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
    var body = jsonEncode({"user": uId});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}user/unfollow"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        RandomFunction.toast(data['response'] ?? "");
        return data;
      } else {
        RandomFunction.toast(data['response'] ?? "");
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

  Future<dynamic> searchPost(String search) async {
    var body = jsonEncode({
      "search_post": search,
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl}search_post.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> getTrending(String basedOn) async {
    var body = jsonEncode({
      basedOn: basedOn,
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl}trending.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> getByTag(String tag) async {
    var body = jsonEncode({
      "search_tag": tag,
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl}search_tags.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> getPostById(String postId) async {
    var body = jsonEncode({
      "post_id": postId,
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid
    });
    try {
      var response = await client
          .post(Uri.parse("${baseurl}get_post_byID.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> createTags(
      Map tag, String postId, String firebaseAuthID) async {
    tag.addAll({"firebaseAuthID": firebaseAuthID, "post_id": postId});
    var body = jsonEncode(tag);
    try {
      var response = await client
          .post(Uri.parse("${baseurl}create_tags.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> sendNotification(String message, String topic,
      {String title = "", String? postId, String? type}) async {
    var map = {
      "to": "/topics/$topic",
      "priority": "high",
      "notification": {"title": title, "body": message},
      "data": {"type": type ?? "blog", "id": postId}
    };

    var body = jsonEncode(map);
    try {
      var response = await client.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": firebaseNotificationKey
          });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> getTopTags() async {
    try {
      var response =
          await client.get(Uri.parse("${baseurl}trending_tags.php"), headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
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

  Future<dynamic> reportPost(int postId, String uid, String comment) async {
    var data = {
      "reporter_firebaseAuthID": uid,
      "post_id": postId,
      "reason": comment
    };
    var body = jsonEncode(data);
    try {
      var response = await client.post(
          Uri.parse("https://api.platterwise.com/jhome/report_post.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        RandomFunction.toast("Report has been submited");
        return data;
      } else {}
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

  Future<dynamic> deletePost(int postId) async {
    var data = {
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "post_id": postId,
    };
    var body = jsonEncode(data);
    try {
      var response = await client.post(
          Uri.parse("https://api.platterwise.com/jhome/delete_post.php"),
          body: body,
          headers: {
            "Content-type": "application/json",
          });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        RandomFunction.toast("Post deleted");
        return data;
      } else {}
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

  Future<Map<String, dynamic>?> searchUser(String query) async {
    final token = LocalStorage.getToken();
    var body = jsonEncode({"name": query});
    try {
      var response = await client.post(Uri.parse("${baseurl3}user/search-name"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      print("The searched user is $data");
      if (data['status_code'] == 200 && data['success'] == true) {
        return data;
      } else {
        RandomFunction.toast(data['response']);
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException catch (_) {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    } catch (e) {
      print(e);
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPostLikes(int postId) async {
    var body = jsonEncode({
      "firebaseAuthID": FirebaseAuth.instance.currentUser!.uid,
      "post_id": postId,
    });
    try {
      var response = await client.post(
        Uri.parse("${baseurl}liker_detail.php"),
        body: body,
        headers: {
          "Content-type": "application/json",
        },
      ).timeout(const Duration(seconds: 10));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
}
