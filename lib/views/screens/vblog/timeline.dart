import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/vblog/create_post/create_post.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.p300,
        child: SvgPicture.asset('assest/icon/edit.svg'),
        onPressed: (){
         nav(context, const CreatePost());
        },
      ),
    );
  }
}
