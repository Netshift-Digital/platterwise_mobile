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
      var response = await client.get(
          Uri.parse("${baseurl3}post/all-posts?page=$pageIndex"),
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

  Future<Map<String, dynamic>?> getLikedPost(int pageIndex, String id) async {
    var token = LocalStorage.getToken();
    var body = jsonEncode({"user_id": id});
    try {
      var response = await client.post(
          Uri.parse("${baseurl3}user/other-user-liked-posts?page=${pageIndex}"),
          body: body,
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

  Future<Map<String, dynamic>?> getUserPost(int index) async {
    String url = "${baseurl3}post/my-posts?page=$index";
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

  Future<Map<String, dynamic>?> getUserFollowers(
      String userId, int index) async {
    String url = "${baseurl3}user/user-followers?page=$index";
    var body = jsonEncode({"user_id": userId});

    var token = LocalStorage.getToken();
    try {
      var response = await client.post(Uri.parse(url), body: body, headers: {
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
      print(e.toString);
      throw Failure("Something went wrong. Try again");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserFollowing(
      String userId, int index) async {
    var body = jsonEncode({"user_id": userId});

    String url = "${baseurl3}user/user-following?page=$index";
    var token = LocalStorage.getToken();
    try {
      var response = await client.post(Uri.parse(url), body: body, headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 60));
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

  Future<Map<String, dynamic>?> getOtherUserPost(int index, String id) async {
    var body = jsonEncode({"user_id": id});

    String url = "${baseurl3}user/other-user-posts?page=$index";
    var token = LocalStorage.getToken();
    try {
      var response = await client.post(Uri.parse(url), body: body, headers: {
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

  Future<Map<String, dynamic>?> getComment(String postId) async {
    var body = jsonEncode({"post_id": postId});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}post/get-post"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      print("These are the results $data");
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

  Future<Map<String, dynamic>?> likePost(int postId) async {
    var body = jsonEncode({"post_id": "$postId"});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}post/like"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
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

  Future<Map<String, dynamic>?> unlikePost(int postId) async {
    var body = jsonEncode({"post_id": "$postId"});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}post/unlike"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
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

  Future<Map<String, dynamic>?> commentToPost(
      int postId, String comment) async {
    var body = jsonEncode({"post_id": "$postId", "comment": comment});
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}post-comment/create"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
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

  Future<Map<String, dynamic>?> fellowUser(String uId) async {
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

  Future<Map<String, dynamic>?> unFellowUser(String uId) async {
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

  Future<Map<String, dynamic>?> searchPost(String search, int page) async {
    var body = jsonEncode({
      "search": search,
    });
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse("${baseurl3}post/search-post?page=$page"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
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

  Future<Map<String, dynamic>?> getTrendingLikes(int page) async {
    var token = LocalStorage.getToken();

    try {
      var response = await client
          .get(Uri.parse("${baseurl3}post/top-liked?page=$page"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
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

  Future<Map<String, dynamic>?> getTrendingComments(int page) async {
    var token = LocalStorage.getToken();

    try {
      var response = await client
          .get(Uri.parse("${baseurl3}post/top-commented?page=$page"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        return data["data"];
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

  Future<Map<String, dynamic>?> getPostById(String postId) async {
    var body = jsonEncode({
      "post_id": postId,
    });
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}post/get-post"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
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

  Future<dynamic> createTags(
      Map tag, String postId, String firebaseAuthID) async {
    tag.addAll({"firebaseAuthID": firebaseAuthID, "post_id": postId});
    var body = jsonEncode(tag);
    print("The create tag body is $body");
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

  Future<Map<String, dynamic>?> deletePost(int postId) async {
    var data = {
      "post_id": "$postId",
    };
    var body = jsonEncode(data);
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}post/delete"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var data = jsonDecode(response.body);
      if (data["status_code"] == 200 && data["success"] == true) {
        RandomFunction.toast(data["response"]);
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
