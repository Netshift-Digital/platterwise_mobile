import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SinglePaymentScreen extends StatelessWidget {
  final SingleTransactionId txn;

  SinglePaymentScreen({
    Key? key,
    required this.txn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("The url is ${txn.authUrl}");
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            Navigator.pop(context, true);
          },
        ),
      )
      ..loadRequest(
        Uri.parse(txn.authUrl),
      );

    return Scaffold(
        // appBar: appBar(context),
        body: SafeArea(
            child: WebViewWidget(
      controller: controller,
    )));
  }
}
