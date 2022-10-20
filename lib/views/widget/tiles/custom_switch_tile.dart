import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class CustomSwitchTile extends StatefulWidget {
  final String text;
  void Function(bool)? onChangeMethod;
  bool? value;

  CustomSwitchTile({
    Key? key,
    required this.text,
    this.value,
    this.onChangeMethod,
  }) : super(key: key);

  @override
  _CustomSwitchTileState createState() => _CustomSwitchTileState();
}

class _CustomSwitchTileState extends State<CustomSwitchTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 5.h, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
          ),
          const Spacer(),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
                trackColor: AppColor.g100,
                activeColor: AppColor.p300,
                value: widget.value!,
                onChanged: widget.onChangeMethod ??
                        (newValue) {
                      setState(() {
                        widget.value = newValue;
                      });
                    }),
          )
        ],
      ),
    );
  }
}