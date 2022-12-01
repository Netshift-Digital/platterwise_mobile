import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/constant/reason.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:provider/provider.dart';

class ReportPost extends StatefulWidget {
 final String postId;
  const ReportPost({Key? key, required this.postId}) : super(key: key);

  @override
  State<ReportPost> createState() => _ReportState();
}

class _ReportState extends State<ReportPost> {
  var groupValue = "";
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    return Scaffold(
      appBar: appBar(context,title: Text('Report Post',
      style: AppTextTheme.h1,)),
      body:Column(
        children: [
          Expanded(child:ListView(
            children: reason().map((e){
              return ListTile(
                title: Text(e),
                trailing: Radio<String>(
                  activeColor: AppColor.p200,
                    value: e,
                    groupValue: groupValue,
                    onChanged: (e){
                  setState(() {
                    groupValue=e!;
                  });
                    }),
              );
            }).toList(),
          )),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: PlatButton(
              appState: model.reportAppState,
              title: 'Submit',
              onTap: () {
                if(groupValue.isNotEmpty){
                 model.reportPost(int.parse(widget.postId),
                     FirebaseAuth.instance.currentUser!.uid, groupValue).
                 then((value){
                   if(value!=null){
                     Navigator.pop(context);
                   }
                 });
                }else{
                  RandomFunction.toast("Select a reason");
                }
              },

            ),
          ),
          const SizedBox(height: 20,),
        ],
      ) ,
    );
  }
}
