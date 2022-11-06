import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/user_activity.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class NotificationActivity extends StatelessWidget {
  const NotificationActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(),
            const SizedBox(height: 30,),
           Text('All activity',style: AppTextTheme.h3.copyWith(
             fontWeight: FontWeight.w700,
             fontSize:16.sp,
             color: Colors.black
           ),),
            const SizedBox(height: 30,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection("activity").
                  doc("users").collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {

                    if(snapshot.hasData){
                      return snapshot.data!.docs.isEmpty?const Center(
                        child:  Padding(
                          padding:  EdgeInsets.only(left: 30,right: 30),
                          child: EmptyContentContainer(),
                        ),
                      ):ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            var encode =  json.encode(snapshot.data!.docs[index].data());
                            Map<String ,dynamic>  user = jsonDecode(encode);
                            var data = UserActivity.fromJson(user);
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                onTap: (){
                                  nav(context, ViewUserProfileScreen(id: data.firebaseAuthId,));
                                },
                               subtitle:Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   const SizedBox(height: 12,),
                                   Text(RandomFunction.date(data.time??DateTime.now().toString()).yMMMd,
                                   style: AppTextTheme.h1.copyWith(
                                     fontSize: 12,
                                     fontWeight: FontWeight.w400,
                                     color: const Color(0xffA7A7A7),
                                   ),),
                                 ],
                               ) ,
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: data.userName,
                                        style: AppTextTheme.h3.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize:14
                                        ),
                                      ),
                                      TextSpan(
                                          text: " ${data.message}",
                                          style: AppTextTheme.h3.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14
                                          ),
                                      ),

                                    ],
                                  ),
                                ),
                                minLeadingWidth: 5,
                                leading: ImageCacheCircle(data.profilePic,
                                height: 35,
                                width: 35,),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                      },
                      );
                    }
                    return const Center(
                      child:  Padding(
                        padding:  EdgeInsets.only(left: 30,right: 30),
                        child: EmptyContentContainer(),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
