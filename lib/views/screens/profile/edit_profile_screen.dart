import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

import '../../../res/color.dart';
import '../../../res/text-theme.dart';

class EditProfileScreen extends StatefulWidget {
final  UserData userData;
  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _imageFile;
  bool isUploading = false;
  String? photoUrl;
  stop(){ setState(() {load=false;});}
  startLoading(){ setState(() {load=true;});}


  Future<void> _pickImage() async {
    var model = context.read<UserViewModel>();
    final ImagePicker picker = ImagePicker();



    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      _imageFile = await image.readAsBytes();
      setState(() {
        _imageFile;
      });
      startLoading();
      model.uploadImage(image.path).then((value){
        photoUrl=value;
        stop();
      }).catchError((e){
        stop();
      });
    }




  }
  var user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool load = false;
  @override
  Widget build(BuildContext context) {
    var model = context.watch<UserViewModel>();
    var userData = model.user!.userProfile;
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: Form(
              key:_formKey ,
              child: Column(
                children: [
                  Center(
                    child: profilePicture(userData),
                  ),
                  SizedBox(height: 20.h,),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      userData.fullName,
                      style: AppTextTheme.h1,
                    ),
                  ),
                  SizedBox(height: 4.h,),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      userData.email??"",
                      style: AppTextTheme.h4,
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  // const Align(
                  //   alignment: Alignment.topLeft,
                  //     child: Text("Address")
                  // ),
                  // SizedBox(height: 8.h,),
                  // AppTextField(
                  //   controller: _address,
                  //   hintText: "My current location",
                  //   validator: FieldValidator.minLength(5,message: "minimum length of bio is 5 letters "),
                  // ),
                  //SizedBox(height: 20.h,),
                 const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Add bio")
                  ),
                  SizedBox(height: 8.h,),
                  AppTextField(
                    controller: _bio,
                    hintText: "Add a brief introduction about you.",
                    maxLines: 6,
                    validator: FieldValidator.minLength(10,message: "minimum length of bio is 10 letters "),
                  ),
                  SizedBox(height: 50.h,),
                  PlatButton(
                      appState: model.appState,
                      title: "Update",
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          var editData = EditData(
                              profileURL:photoUrl??userData.profileUrl ,
                              firebaseAuthID: FirebaseAuth.instance.currentUser!.uid,
                              bio: _bio.text,

                              location: _address.text
                          );
                          model.editUser(editData).then((value){
                            Navigator.pop(context);
                          });
                        }
                      }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicture(UserProfile userProfile) {
    return Stack(
        children: <Widget>[
          //TODO: Switch Person Image and connect to backend
          CircleAvatar(
              radius: 36,
              backgroundColor: AppColor.g600,
              child: _imageFile != null
                  ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    image: DecorationImage(
                        image: MemoryImage(_imageFile!), fit: BoxFit.cover)),
              )
                  : ImageCacheCircle(userProfile.profileUrl,
              height:72,
                width:72,
              )
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: _pickImage,
              child: isUploading
                  ? const SizedBox(
                  width: 10, height: 10, child: CircularProgressIndicator())
                  : SvgPicture.asset(
                "assets/icon/edit-pen.svg",
                width: 28,
                height: 28,
              ),
            ),
          ),
        load==false?const SizedBox():const  SizedBox(
            height: 75,
              width: 75,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.p200),
              )),
        ]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _address.text=widget.userData.userProfile.location;
    _bio.text=widget.userData.userProfile.bio;
  }
}
