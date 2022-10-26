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
            Divider(
              thickness: 1,
              color: AppColor.g40,
            ),
            SizedBox(height: 40.h,),
            SettingsTile(
              title: "Profile",
              leading: "assets/icon/user.svg",
              onTap: () {

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


}
