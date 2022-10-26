import 'package:flutter/material.dart';

class ViewPostsPage extends StatefulWidget {
  const ViewPostsPage({Key? key}) : super(key: key);

  @override
  State<ViewPostsPage> createState() => _ViewPostsPageState();
}

class _ViewPostsPageState extends State<ViewPostsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Posts Page"),
    );
  }
}
