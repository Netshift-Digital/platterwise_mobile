import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/model/request_model/register_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/auth/otp.dart';
import 'package:platterwave/views/screens/auth/profile_pic.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/country_field.dart';
import 'package:platterwave/views/widget/text_feild/text_field.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

class Register extends StatefulWidget {
   Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    final TextEditingController _fullName =  TextEditingController();

   final TextEditingController _email =  TextEditingController();

   final TextEditingController _username =  TextEditingController();

   final TextEditingController _password =  TextEditingController();

   final TextEditingController _confirmPassword =  TextEditingController();

   final TextEditingController _phoneNumber =  TextEditingController();

   final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: AnnotatedRegion(
        value: kOverlay,
        child: Scaffold(
         // appBar: appBar(context),
          body: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: sixteen,right: sixteen,bottom: sixteen),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const SizedBox(height: twenty,),
                       Text("Create your account",style: AppTextTheme.h4.copyWith(
                         fontSize: twentyFour,
                         fontWeight: FontWeight.w700
                       ),),
                      const SizedBox(height: fiftyFour,),
                      Text("Full name",style: AppTextTheme.hint),
                      const SizedBox(height: hintSpacing,),
                      Field(
                          controller: _fullName,
                          hint: "John Doe",
                          validate: FieldValidator.minLength(3),
                      ),
                      const SizedBox(height: twenty,),
                      Text("Email",style: AppTextTheme.hint),
                      const SizedBox(height: hintSpacing,),
                      Field(
                        controller: _email,
                        hint: "gsswuw@gmail.com",
                        validate: FieldValidator.email(),
                      ),
                      const SizedBox(height: twenty,),
                      Text("Username",style: AppTextTheme.hint),
                      const SizedBox(height: hintSpacing,),
                      Field(
                        controller: _username,
                        hint: "Johndone12",
                        validate: FieldValidator.minLength(3),
                      ),
                      const SizedBox(height: twenty,),
                      Text("Password",style: AppTextTheme.hint),
                      const SizedBox(height: hintSpacing,),
                      Field(
                        controller: _password,
                        hint: "••••••••••••••",
                        isPassword: true,
                        validate: FieldValidator.minLength(3),
                      ),
                      const SizedBox(height: twenty,),
                      Text("Phone number",style: AppTextTheme.hint),
                      const SizedBox(height: hintSpacing,),
                      CountryField(
                        controller: _phoneNumber,
                        hint: "55-0114-2346",
                        validate: FieldValidator.minLength(3),
                      ),
                      const SizedBox(height: forty,),
                      PlatButton(
                         appState:context.watch<UserViewModel>().appState ,
                          title: "Create your account",
                          onTap: (){
                           if(_formKey.currentState!.validate()){
                             register(context);
                           }

                          }
                      ),
                      const SizedBox(height: eighteen,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(),
                          Text("We won't share your information without your permission",
                              style: AppTextTheme.hint.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                  color: AppColor.g100
                              )
                          ),
                          const SizedBox(height: hintSpacing,),
                          GestureDetector(
                            onTap: (){
                              nav(context, Login());
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: AppTextTheme.h6.copyWith(
                                        fontSize: 14,
                                      color: AppColor.g500
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign in',
                                    style: AppTextTheme.h6.copyWith(
                                        color:AppColor.p200,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register(BuildContext context) async{
    var model =  context.read<UserViewModel>();
   // var imagePath = await Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePic()));
    model.registerUser(
        RegisterModel(
             fullName: _fullName.text,
             email: _email.text,
             password: _password.text,
             phone: _phoneNumber.text,
             username: _username.text,
             imageUrl:"https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
             authId: ""
        ),"").then((value){
              if(value==true){
                RandomFunction.toast("Account created successfully, a verification mail has been sent to you");
                FirebaseAuth.instance.currentUser!.sendEmailVerification();
               nav(context,Login());

              }
    });
  }
}
