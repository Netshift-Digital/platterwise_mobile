import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/profile/edit_password.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/tiles/custom_switch_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var userId = LocalStorage.getUserId();
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80.h,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditPasswordScreen();
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change password"),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.g100,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 37.h,
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('followButton')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!.exists) {
                    var data = snapshot.data!.data()! as Map;

                    return CustomSwitchTile(
                      text: "Disable follow button",
                      value: data['disable'] ?? false,
                      onChangeMethod: (e) {
                        FirebaseFirestore.instance
                            .collection('followButton')
                            .doc(userId)
                            .set({"disable": e});
                      },
                    );
                  }
                  return CustomSwitchTile(
                    text: "Disable follow button",
                    value: false,
                    onChangeMethod: (e) {
                      FirebaseFirestore.instance
                          .collection('followButton')
                          .doc(userId)
                          .set({"disable": e});
                    },
                  );
                }),
            SizedBox(
              height: 4.h,
            ),
            const Text(" User would not be able to follow your account"),
            SizedBox(
              height: 32.h,
            ),
            CustomSwitchTile(
              text: "Pause notification",
              value: true,
            ),
          ],
        ),
      ),
    );
  }
}
