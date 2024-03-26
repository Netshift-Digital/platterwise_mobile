import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/request_model/edit_data.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:platterwave/views/widget/text_feild/text_field.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

import '../../../res/color.dart';
import '../../../res/text-theme.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userData;
  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _imageFile;
  bool isUploading = false;
  String? photoUrl;
  stop() {
    if (mounted) {
      setState(() {
        load = false;
      });
    }
  }

  startLoading() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  Future<void> _pickImage() async {
    var model = context.read<UserViewModel>();
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = await image.readAsBytes();
      setState(() {
        _imageFile;
      });
      startLoading();
      model.uploadImage(image.path).then((value) {
        photoUrl = value;
        stop();
      }).catchError((e) {
        stop();
      });
    }
  }

  final TextEditingController _bio = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool load = false;
  @override
  Widget build(BuildContext context) {
    var model = context.watch<UserViewModel>();
    var userData = model.user;
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: profilePicture(userData!),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      userData.fullName,
                      style: AppTextTheme.h1,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "@${userData.username}" ?? " ",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColor.p300),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Account Full Name")),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    controller: _fullName,
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    validator: FieldValidator.minLength(3),
                  ),
                  const SizedBox(
                    height: twenty,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Username"),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    controller: _userName,
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    validator: FieldValidator.minLength(3),
                  ),
                  const SizedBox(
                    height: twenty,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Phone Number")),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    controller: _number,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    validator: FieldValidator.number(),
                  ),
                  const SizedBox(
                    height: twenty,
                  ),

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
                      alignment: Alignment.topLeft, child: Text("Add bio")),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    controller: _bio,
                    hintText: "Add a brief introduction about you.",
                    maxLines: 6,
                    validator: FieldValidator.minLength(8,
                        message: "minimum length of bio is 10 letters "),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  PlatButton(
                      appState: model.appState,
                      title: "Update",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          var editData = EditData(
                              profileURL: photoUrl ?? userData.profileUrl,
                              bio: _bio.text,
                              location: _address.text,
                              fullName: _fullName.text,
                              username: _userName.text,
                              email: _email.text,
                              number: _number.text);
                          model.editUser(editData).then((value) {
                            Navigator.pop(context, true);
                          });
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicture(UserProfile userProfile) {
    return Stack(children: <Widget>[
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
              : ImageCacheCircle(
                  userProfile.profileUrl,
                  height: 72,
                  width: 72,
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
      ),
      load == false
          ? const SizedBox()
          : const SizedBox(
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
    _address.text = widget.userData.location;
    _bio.text = widget.userData.bio;
    _fullName.text = widget.userData.fullName;
    _userName.text = widget.userData.username;
    _number.text = widget.userData.phone;
    _email.text = widget.userData.email;
  }
}
