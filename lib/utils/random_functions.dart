
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:jiffy/jiffy.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:platterwave/res/color.dart';
import 'package:provider/provider.dart';

class RandomFunction {
  static toast(String msg, {bool isError = false}) {
    var cancel = BotToast.showSimpleNotification(title: msg,);

  }


  static String greetingMessage(){
    var timeNow = DateTime.now().hour;
    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  static Jiffy date(String date){
    var d = DateTime.tryParse(date)??DateTime.now();
    return Jiffy({
      "year": d.year,
      "month": d.month,
      "day": d.day,
      "hour": d.hour,
      "minute":d.minute
    });
  }



  static sheet(BuildContext context,Widget body,{double? height}) {
    var size = MediaQuery.of(context).size;
    showCupertinoModalPopup(
        context: context,
        builder: (context){
          return Container(
            height:height??size.height-120,
            width: size.width,
            decoration: const BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
                )

            ),
            child: body,
          );
        }
    );
  }



  static String timeAgo(String date){
    var d = DateTime.parse(date);
    var result = GetTimeAgo.parse(d);
    return result;
  }

  static Color reserveColor(String e){
    if(e.contains('pend')){
      return Colors.orange;
    }else if(e.contains('accep')){
      return Colors.blue;
    }else if(e.contains('can')){
      return Colors.red;
    }else if(e.contains('suc')){
      return Colors.green;
    }else{
      return Colors.orange;
    }
  }

}
