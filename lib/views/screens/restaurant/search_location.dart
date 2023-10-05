import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';

class LocationSearchScreen extends StatelessWidget {
  LocationSearchScreen({Key? key}) : super(key: key);

  List<String> allRestDetail = [];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final p = PlacesAutocomplete.show(
    // context: context, apiKey: "AIzaSyC44N6yERgjg8AM_UOznKlflcEZWYE8tro");
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 33.h,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: allRestDetail.length,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    var data = allRestDetail[index];
                    return Text("");
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20.h,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
