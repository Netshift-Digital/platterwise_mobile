import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/user_activity.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
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
                      ):ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            var encode =  json.encode(snapshot.data!.docs[index].data());
                            Map<String ,dynamic>  user = jsonDecode(encode);
                            var data = UserActivity.fromJson(user);
                            return ListTile(
                              title:Text("${data.userName}${data.message}"),
                              leading: ImageCacheCircle(data.profilePic,
                              height: 50,
                              width: 50,),
                            );
                          }
                      );
                    }
                    return Center(
                      child: const Padding(
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
