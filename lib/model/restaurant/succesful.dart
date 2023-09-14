import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:provider/provider.dart';

class Successful extends StatelessWidget {
  const Successful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 40,
                        color: Colors.grey,
                      ))
                ],
              ),
              const Spacer(
                flex: 2,
              ),
              Image.asset('assets/images/Check gif.gif'),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Congratulations',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Your reservation is successful.\nThe restaurant will contact you shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              PlatButton(
                title: "Home",
                onTap: () {
                  context.read<PageViewModel>().setIndex(1);
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
