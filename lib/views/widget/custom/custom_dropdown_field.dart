


import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> item;
  final String? dropDownValue;
  final Widget? prefixIcon;
  final String hint;
  final Function(String?)? onChanged;
  const CustomDropDown({Key? key,
  required this.item,
    required this.dropDownValue,
    required this.hint,
    required this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      icon: const Icon(
        Icons.expand_more_outlined,
        color: AppColor.p50,
      ),
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide:
          BorderSide(color: AppColor.p50),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.p50,width: 1),
        ),
        border:  const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.p50,width: 1),
        ),
        hintStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColor.p50,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10,),
        hintText: hint,
        prefixIcon: prefixIcon,
      ),
      items: item
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
