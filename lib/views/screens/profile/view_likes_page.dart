import 'package:flutter/material.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';

class ViewLikesPage extends StatefulWidget {
  const ViewLikesPage({Key? key}) : super(key: key);

  @override
  State<ViewLikesPage> createState() => _ViewLikesPageState();
}

class _ViewLikesPageState extends State<ViewLikesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyContentContainer(
        errorText: "Like your first post by going to homepage "
            "and follow the accounts you are intrested in",
      ),
    );
  }
}
