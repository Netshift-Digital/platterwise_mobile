import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:provider/provider.dart';

class Field extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefixIcon;
  final double height, width, borderRadius;
  final TextInputType textInputType;
  final Function(String)? validate;
  final Color fillColor;
  final bool isPassword, enable;
  final Function? onTap;
  final Widget? suffixIcon;
  const Field(
      {required this.controller,
      this.height = 54,
      this.onTap,
      this.enable = true,
      required this.validate,
      this.fillColor = const Color(0xffF2F2F2),
      this.width = double.maxFinite,
      this.isPassword = false,
      this.borderRadius = 10,
      this.hint = "",
      this.textInputType = TextInputType.text,
      this.prefixIcon,
      this.suffixIcon,
      Key? key})
      : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        widget.onTap;
      },
      obscureText: secure,
      enabled: widget.enable,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      validator: (e) {
        return widget.validate == null ? null : widget.validate!(e!);
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              //  color:model.themeData.iconTheme.color!.withOpacity(0.5)
              ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColor.g50),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColor.p100),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColor.g50),
        ),
        suffixIcon: widget.isPassword
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        setSecure();
                      },
                      child: icon()),
                ],
              )
            : widget.suffixIcon,
      ),
    );
  }

  setSecure() {
    setState(() {
      secure = !secure;
    });
  }

  Widget icon() {
    if (secure) {
      return Text(
        "show",
        style: AppTextTheme.h6.copyWith(
            fontWeight: FontWeight.w500, color: AppColor.g600, fontSize: 14),
      );
    } else {
      return Text(
        "hide",
        style: AppTextTheme.h6.copyWith(
            fontWeight: FontWeight.w500, color: AppColor.g600, fontSize: 14),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isPassword) {
      setState(() {
        secure = false;
      });
    }
  }
}
