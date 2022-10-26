import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

import '../../../res/color.dart';
import '../../../res/text-theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _imageFile;
  bool isUploading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    _imageFile = await image!.readAsBytes();
    setState(() {
      _imageFile;
    });

    if (_imageFile == null) return;
    if (!mounted) return;

    // String photoUrl = '';
    // String userType =
    // await Provider.of<ScreenDecider>(context, listen: false).getUserType();
    //
    // setState(() => isUploading = true);
    // try {
    //   photoUrl = await FirebaseStorageService.uploadImageToStorage(
    //       userType, _imageFile, FirebaseAuthService().uuid);
    // } catch (e) {
    //   //
    // }
    //
    // FirebaseUserService(collection: userType).updateUserInfo(
    //   uuid: FirebaseAuthService().uuid,
    //   info: {"photoUrl": photoUrl},
    // );
    // setState(() => isUploading = false);
  }
  var user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var model = context.watch<UserViewModel>();
    SizeConfig.init(context);
    return Scaffold(
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
                  child: profilePicture(),
                ),
                SizedBox(height: 20.h,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Eti chisom",
                    style: AppTextTheme.h1,
                  ),
                ),
                SizedBox(height: 4.h,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.email??"",
                    style: AppTextTheme.h4,
                  ),
                ),
                SizedBox(height: 30.h,),
                const Align(
                  alignment: Alignment.topLeft,
                    child: Text("Address")
                ),
                SizedBox(height: 8.h,),
                AppTextField(
                  controller: _address,
                  hintText: "my current location",
                  validator: FieldValidator.minLength(5,message: "minimum length of bio is 5 letters "),
                ),
                SizedBox(height: 20.h,),
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
                            firebaseAuthID: "hhjhgvv",
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
    );
  }

  Widget profilePicture() {
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
                  : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    image: const DecorationImage(
                        image: NetworkImage("https://thumbs.dreamstime.com/b/lonely-elephant-against-sunset-beautiful-sun-clouds-savannah-serengeti-national-park-africa-tanzania-artistic-imag-image-106950644.jpg"),
                        fit: BoxFit.cover)),
              )),
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
          )
        ]);
  }
}
