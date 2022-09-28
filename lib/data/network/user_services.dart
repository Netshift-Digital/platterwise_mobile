import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/Failure.dart';
import 'package:platterwave/model/request_model/register.dart';
import 'package:platterwave/utils/random_functions.dart';


class UserService{
  var client = http.Client();



  Future<dynamic> signUp(RegisterModel registerModel) async {
    var body = jsonEncode(registerModel.toJson());
    print(registerModel.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl}createacc_json.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      print(data);
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

}