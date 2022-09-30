import 'package:flutter/material.dart';
import 'package:platterwave/res/text-theme.dart';


class CustomAlert{
  String title;
  String body;
  Function() onTap;
  BuildContext context;

  CustomAlert({
    required this.context,
    required this.title,
    required this.body,
    required this.onTap});

  show(){
    showDialog(context: context,
        builder:(context){
          return AlertDialog(
            title: Text(title,style:AppTextTheme.h2.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15
            )),
            content: Text(body,style:AppTextTheme.h2.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 13
            )),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:  Text('cancel',style:AppTextTheme.h2.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                  ) ,)
              ),
              TextButton(
                  onPressed:(){
                    Navigator.pop(context);
                    onTap();

                  },
                  child:  Text('confirm',style:AppTextTheme.h2.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13
                  ))
              ),
            ],
          );
        }
    );
  }
}