import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

import '../../../res/color.dart';
import '../../widget/button/custom-button.dart';
import '../../widget/text_feild/app_textfield.dart';

class EditPasswordScreen extends StatefulWidget {
   EditPasswordScreen({Key? key}) : super(key: key);

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
 final TextEditingController _password = TextEditingController();

   final TextEditingController _confirmPassword = TextEditingController();

   final TextEditingController _currentPassword = TextEditingController();

   final _forKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var model = context.watch<UserViewModel>();
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key:_forKey ,
            child: Column(
              children: [
                SizedBox(height: 100.h,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Current Password")
                ),
                SizedBox(height: 8.h,),
                AppTextField(
                  obscureText: true,
                  controller: _currentPassword,
                  validator: FieldValidator.password(),
                ),
                SizedBox(height: 20.h,),
               const Align(
                    alignment: Alignment.topLeft,
                    child: Text("New Password")
                ),
                SizedBox(height: 8.h,),
                AppTextField(
                  obscureText: true,
                  controller: _password,
                  validator: FieldValidator.password(),
                ),
                SizedBox(height: 20.h,),
               const  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Confirm New Password")
                ),
                SizedBox(height: 8.h,),
                AppTextField(
                  obscureText: true,
                  controller: _confirmPassword,
                  validator: (e){
                    if(_confirmPassword.text.trim()!=e){
                      return "password does not match";
                    }
                  },
                ),
                SizedBox(height: 220.h,),
                PlatButton(
                  appState: model.appState,
                    title: "Change Password",
                    onTap: (){
                      if(_forKey.currentState!.validate()){
                        model.changePassword(_password.text,_currentPassword.text).then((value){
                          if(value){
                            Navigator.pop(context);
                          }
                        });
                      }

                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
