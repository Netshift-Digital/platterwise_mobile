import 'package:flutter/material.dart';

class ViewLikesPage extends StatefulWidget {
  const ViewLikesPage({Key? key}) : super(key: key);

  @override
  State<ViewLikesPage> createState() => _ViewLikesPageState();
}

class _ViewLikesPageState extends State<ViewLikesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Likes Page"),
    );
  }
}
