import 'package:flutter/material.dart';

nav(BuildContext context,Widget screen,{bool remove = false}){
  if(remove){
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context)=>screen)
        , (route) => false);
  }else{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>screen));
  }
}

