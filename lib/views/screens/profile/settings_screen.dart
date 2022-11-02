import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          children: [
            SizedBox(height: 80.h,),
            InkWell(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context){
                  return EditPasswordScreen();
                })
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change password"),
                  Icon(Icons.arrow_forward_ios,color: AppColor.g100,)
                ],
              ),
            ),
            SizedBox(height: 37.h,),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('followButton')
                  .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.data!=null&&snapshot.data!.exists){
                  var data = snapshot.data!.data()! as Map;

                return CustomSwitchTile(
                    text: "Allow people follow you",
                  value: data['disable']??false,
                  onChangeMethod: (e){
                      FirebaseFirestore.instance.collection('followButton')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({"disable":e});
                  },
                );
                }
                return CustomSwitchTile(
                  text: "Allow people follow you",
                  value: false,
                  onChangeMethod: (e){
                    FirebaseFirestore.instance.collection('followButton')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({"disable":e});
                  },
                );
              }
            ),
            SizedBox(height: 14.h,),
           const Text("Your followers will be notified about post you"
                " make to your profile and see them in their home feed."),
            SizedBox(height: 32.h,),
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
