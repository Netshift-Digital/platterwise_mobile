
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class Field extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefixIcon;
  final double height,width,borderRadius;
  final TextInputType textInputType;
  final Function(String)? validate;
  final Color fillColor;
  final bool isPassword,enable;
  final Function? onTap;
  final Widget? suffixIcon;
  const Field({
    required this.controller,
    this.height=54,
    this.onTap,
    this.enable=true,
    required this.validate,
    this.fillColor=const Color(0xffF2F2F2),
    this.width=double.maxFinite,
    this.isPassword=false,
    this.borderRadius=10,
    this.hint="",
    this.textInputType=TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    Key? key}) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: (){
        widget.onTap;
      },
      obscureText: secure,
      enabled: widget.enable,
      controller:widget.controller ,
      keyboardType: widget.textInputType,
      validator: (e){
        return widget.validate==null?null:widget.validate!(e!);
      },
      decoration: InputDecoration(
       labelText: widget.hint,
        prefixIcon: widget.prefixIcon,
        disabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(
            //  color:model.themeData.iconTheme.color!.withOpacity(0.5)
          ),
        ) ,
        focusedBorder:  UnderlineInputBorder(
          borderSide:  BorderSide(
              //color:model.themeData.iconTheme.color!.withOpacity(0.5)
          ),
        ),
        suffixIcon: widget.isPassword?InkWell(
            onTap: (){
              setSecure();
            },
            child: icon()):widget.suffixIcon,


      ),

    );
  }

  setSecure(){
    setState((){
      secure=!secure;
    });
  }

  Widget icon() {
    if(secure){
      return const Icon(Icons.visibility_outlined);
    }else{
      return const Icon(Icons.visibility_off_outlined);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isPassword){
      setState(() {
        secure=false;
      });
    }
  }
}
