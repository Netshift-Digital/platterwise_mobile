import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/profile/edit_profile_screen.dart';
import 'package:platterwave/views/screens/profile/settings_screen.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';

import '../../../res/color.dart';
import '../../../res/text-theme.dart';
import '../../widget/tiles/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
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
            SizedBox(height: 24.h,),
            Divider(
              thickness: 1,
              color: AppColor.g40,
            ),
            SizedBox(height: 40.h,),
            SettingsTile(
              title: "Profile",
              leading: "assets/icon/user.svg",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context){
                      return EditProfileScreen();
                })
                );
              },
            ),
            SizedBox(height: 25.h,),
            SettingsTile(
              title: "Settings",
              leading: "assets/icon/settings.svg",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context){
                  return SettingsScreen();
                })
                );
              },
            ),
            SizedBox(height: 25.h,),
            SettingsTile(
              title: "Content and Privacy Policy",
              leading: "assets/icon/note-text.svg",
              onTap: () {},
            ),
            SizedBox(height: 25.h,),
            SettingsTile(
              title: "Help Center",
              leading: "assets/icon/help-center-icon.svg",
              onTap: () {},
            ),
            SizedBox(height: 45.h,),
            SettingsTile(
              title: "Logout",
              leading: "assets/icon/logout.svg",
              onTap: () {},
            ),

          ],
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
