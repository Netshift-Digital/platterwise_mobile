import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:platterwave/common/base_view_model.dart';
import 'package:platterwave/utils/constant.dart';
import 'package:platterwave/utils/location_service.dart';
import 'package:platterwave/utils/locator.dart';

class LocationProvider extends BaseViewModel {
  String _address = '';
  String _lat = '';
  String _long = "";
  String _state = "";

  String get long => _long;
  String get lat => _lat;
  String get state => _state;
  String get address => _address;
  LocationService locationService = locator<LocationService>();
  var box = Hive.box('post');

  set myAddress(String newAddress) {
    _address = newAddress;
    notifyListeners();
  }

  set lat(String value) {
    _lat = value;
    notifyListeners();
  }

  Future<LocationData> getPlaceDetails(String place) async {
    List<Location> locations = await locationFromAddress(place);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      locations.first.latitude,
      locations.first.longitude,
    );
    return LocationData(placemarks.first,
        LatLong(locations.first.latitude, locations.first.longitude));
  }

  set long(String value) {
    _long = value;
    notifyListeners();
  }

  getLocation() {
    locationService.determinePosition().then((value) {
      locationService.getAddressFromPosition(value).then((place) {
        _address = '${place.locality} ${place.administrativeArea}';
        _lat = value.latitude.toString();
        _long = value.longitude.toString();
        _state = place.locality ?? "";
        save();
        notifyListeners();
      });
    });
  }

  save() {
    box.put('location',
        {'lat': _lat, "long": _long, "address": _address, "state": _state});
  }

  getStoredLocation() {
    var data = box.get('location');
    if (data == null) {
      getLocation();
    } else {
      _lat = data['lat'];
      _long = data['long'];
      _address = data['address'];
      _state = data['state'];
      notifyListeners();
    }
  }
}

class LocationData {
  LatLong latLong;
  Placemark placeMark;
  LocationData(this.placeMark, this.latLong);
}
