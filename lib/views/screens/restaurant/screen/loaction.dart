import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';

class LocationSelect extends StatelessWidget {
  const LocationSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          title: const Text(
            "Pick a location",
            style: TextStyle(color: Colors.black87),
          )),
      body: FlutterLocationPicker(
        initPosition: LatLong(6.45407 ,3.39467),
        selectLocationButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        selectLocationButtonText: 'Set Current Location',
        initZoom: 11,
        minZoomLevel: 5,
        maxZoomLevel: 16,
        trackMyPosition: true,
        onError: (e) => print(e),
        onPicked: (pickedData) {
          print(pickedData.latLong.latitude);
          print(pickedData.latLong.longitude);
          print(pickedData.address);
          print(pickedData.addressData['country']);
        },
      ),
    );
  }
}
