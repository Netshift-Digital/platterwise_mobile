import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String leading;
  final Color color;
  final VoidCallback? onTap;
  final bool trailingVisible;

  const SettingsTile({
    Key? key,
    required this.title,
    required this.leading,
    this.color = Colors.black,
    this.onTap,
    this.trailingVisible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(leading, color: color,),
      onTap: onTap,
      title: Text(title,),
      trailing: Visibility(
          visible: trailingVisible,
          child: Icon(Icons.chevron_right)
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      horizontalTitleGap: 0,
    );
  }
}