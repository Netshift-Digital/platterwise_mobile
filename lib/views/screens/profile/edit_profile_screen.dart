import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';

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
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          physics:const BouncingScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: profilePicture(),
              ),
              SizedBox(height: 20.h,),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Esther Howard",
                  style: AppTextTheme.h1,
                ),
              ),
              SizedBox(height: 4.h,),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "@annaclaramm",
                  style: AppTextTheme.h4,
                ),
              ),
              SizedBox(height: 24.h,),              Align(
                alignment: Alignment.topLeft,
                  child: Text("Display Name")
              ),
              SizedBox(height: 8.h,),
              AppTextField(
                hintText: "John Doe",
              ),
              SizedBox(height: 18.h,),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Username")
              ),
              SizedBox(height: 8.h,),
              AppTextField(
                hintText: "Johndoe12",
              ),
              SizedBox(height: 18.h,),
              // Align(
              //     alignment: Alignment.topLeft,
              //     child: Text("Gender")
              // ),
              // SizedBox(height: 8.h,),
              // AppTextField(
              //   hintText: "Male",
              // ),
              SizedBox(height: 18.h,),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Add bio")
              ),
              SizedBox(height: 8.h,),
              AppTextField(
                hintText: "Add a brief introduction about you.",
                maxLines: 6,
              ),
              SizedBox(height: 70.h,),
              PlatButton(
                  title: "Update",
                  onTap: (){}
              )
            ],
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
                    image: DecorationImage(
                        image: NetworkImage(""),
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
