import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:platterwave/constant/endpoint.dart';
import 'package:platterwave/model/failure.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/utils/random_functions.dart';


class UserService{
  var client = http.Client();



  Future<dynamic> signUp(RegisterModel registerModel) async {
    var body = jsonEncode(registerModel.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl}createacc_json.php"), body: body, headers: {
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




  Future<dynamic> editProfile(EditData editData) async {
    var body = jsonEncode(editData.toJson());
    try {
      var response =
      await client.post(Uri.parse("${baseurl}edit_user.php"), body: body, headers: {
        "Content-type": "application/json",
      });
      var data = jsonDecode(response.body);
      RandomFunction.toast(data['status']??"");
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

}