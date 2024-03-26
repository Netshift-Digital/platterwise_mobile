import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/utils/random_functions.dart';

class UserService {
  var client = http.Client();

  Future<dynamic> signUp(RegisterModel registerModel) async {
    try {
      var response = await client.post(Uri.parse("${baseurl3}auth/register"),
          body: jsonEncode(registerModel.toJson()),
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 60));
      var data = jsonDecode(response.body);
      print("The data is $data");
      if (response.statusCode == 200 && data["status"] == true) {
        return data;
      } else {
        if ((data["response"] as String).contains("validat")) {
          RandomFunction.toast((data['data'] as List).join(","));
        } else {
          RandomFunction.toast(data['response'] ?? "");
        }
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

  Future<dynamic> signIn(String email, String password) async {
    var boDy = {"email": "$email", "password": "$password"};
    try {
      var response = await client.post(Uri.parse("${baseurl3}auth/login"),
          body: jsonEncode(boDy),
          headers: {
            "Content-type": "application/json",
          }).timeout(const Duration(seconds: 60));

      var data = jsonDecode(response.body);
      print("This is the data $data");

      if (data["status_code"] == 200 && data["success"] == true) {
        print("This is the data $data");
        var token = data["token"]["original"]["access_token"];
        print("This is the user token $token");
        LocalStorage.saveToken(token);
        LocalStorage.saveLoginTime();
        LocalStorage.saveEmail(data["data"]["original"]["email"]);
        LocalStorage.saveUserId(data["data"]["original"]["id"]);
        LocalStorage.saveUser(data["data"]["original"]);
        return data;
      } else {
        if ((data["response"] as String).contains("validat")) {
          RandomFunction.toast((data['data'] as List).join(","));
        } else {
          RandomFunction.toast(data['response'] ?? "");
        }
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

  Future<dynamic> editProfile(EditData editData) async {
    var body = jsonEncode(editData.toJson());
    print("Here is the edit profile body $body");
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(Uri.parse("${baseurl3}user/edit"),
          body: body,
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 60));
      var data = jsonDecode(response.body);
      print("The edit profile result is $data");
      RandomFunction.toast(data["response"]);
      if (data["status_code"] == 200 && data["success"] == true) {
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

  Future<Map<String, dynamic>?> getMyProfile() async {
    var token = LocalStorage.getToken();

    try {
      var response = await client.get(Uri.parse("${baseurl3}user/profile"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 60));
      var data = jsonDecode(response.body);

      print("This user profile is $data");
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

  Future<Map<String, dynamic>?> logout() async {
    var token = LocalStorage.getToken();

    try {
      var response = await client.post(
          Uri.parse(
            "${baseurl3}user/logout",
          ),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);

      print("This user profile is $data");
      print("This user profile is ${response.statusCode}");
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>?> validateEmail(String email) async {
    var token = LocalStorage.getToken();
    var boDy = {"email": email};

    try {
      var response = await client.post(
          Uri.parse(
            "${baseurl3}auth/validate-email",
          ),
          body: jsonEncode(boDy),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);
      print("The body is ------------- $data");

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

  Future<Map<String, dynamic>?> resetPassword(
      String email, String password, String token) async {
    var tokenT = LocalStorage.getToken();
    var boDy = {"email": email, "password": password, "token": token};

    try {
      var response = await client.post(
          Uri.parse(
            "${baseurl3}auth/reset-password",
          ),
          body: jsonEncode(boDy),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $tokenT"
          }).timeout(const Duration(seconds: 20));
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

  Future<Map<String, dynamic>?> getOtherUserProfile(String id) async {
    var token = LocalStorage.getToken();
    var boDy = {"user_id": id};

    try {
      var response = await client.post(
          Uri.parse(
            "${baseurl3}user/other-user",
          ),
          body: jsonEncode(boDy),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(const Duration(seconds: 20));
      var data = jsonDecode(response.body);

      print("This user profile is $data");
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
}
