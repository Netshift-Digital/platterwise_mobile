import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/size_config/size_config.dart';

class AppTextField extends StatelessWidget {
  final bool? autofocus;
  final bool? readOnly;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final double borderRadius;
  final TextInputType? keyboardType;
  final String? hintText;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final bool hasBorder;
  final bool isSearch;
  final Color? fillColor;
  final int? maxLines;
  final bool? enabled;
  final void Function()? onTap;
  final double contentPadding;
  final String? initialValue;
  final TextStyle style;

  const AppTextField({
    Key? key,
    this.autofocus,
    this.readOnly,
    this.autovalidateMode,
    this.validator,
    this.borderRadius = 8,
    this.keyboardType,
    this.hintText,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.hasBorder = true,
    this.isSearch = false,
    this.fillColor = Colors.transparent,
    this.maxLines = 1,
    this.enabled,
    this.onTap,
    this.contentPadding = 0,
    this.initialValue,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: TextFormField(
        autofocus: autofocus ?? false,
        readOnly: readOnly ?? false,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        //obscuringCharacter: '●',
        initialValue: initialValue,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        autovalidateMode:
        autovalidateMode ?? AutovalidateMode.onUserInteraction,
        validator: validator,
        obscureText: obscureText,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 0, color: AppColor.p200),
          ),
          isDense: true,
          fillColor: fillColor,

          filled: true,
          contentPadding: EdgeInsets.all(
            hasBorder
                ? 16
                : isSearch
                ? 16
                : contentPadding,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon != null
              ? UnconstrainedBox(
            alignment: hasBorder ? Alignment.center : Alignment.center,
            child: suffixIcon,
          )
              : null,
          prefixIcon: prefixIcon != null
              ? UnconstrainedBox(
            alignment: hasBorder
                ? Alignment.center
                : isSearch
                ? Alignment.center
                : Alignment.topCenter,
            child: prefixIcon,
          )
              : null,
          border: hasBorder
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(),
          )
              : isSearch
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          )
              : OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          errorBorder: hasBorder
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            //borderSide: const BorderSide(color: kSecondary),
          )
              : isSearch
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          )
              : InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}