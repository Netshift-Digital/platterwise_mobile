import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:platterwave/common/base_view_model.dart';
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
    _long =  locations.first.longitude.toString();
    _lat = locations.first.latitude.toString();
    print(_long);
    print(_lat);
    _address = place;
    _state = placemarks.first.administrativeArea??"";
    save();
    return LocationData(placemarks.first.administrativeArea ?? "",
        LatLong(locations.first.latitude, locations.first.longitude));
  }

  set long(String value) {
    _long = value;
    notifyListeners();
  }

  Future<LocationData> getLocation() async{
   var value = await  locationService.determinePosition();
   var place =await locationService.getAddressFromPosition(value);
   _address = '${place.locality} ${place.administrativeArea}';
   _lat = value.latitude.toString();
   _long = value.longitude.toString();
   _state = place.locality ?? "";
   notifyListeners();
   return LocationData( _state,LatLong(double.parse(_lat), double.parse(_long)));
  }

  save() {
    box.put('location',
        {'lat': _lat, "long": _long, "address": _address, "state": _state});
  }

 LocationData? getStoredLocation({bool update = true}) {
    var data = box.get('location');
    if (data != null) {
      _lat = data['lat'];
      _long = data['long'];
      _address = data['address'];
      _state = data['state'];
      if(update){
        notifyListeners();
      }
      return LocationData( _state,LatLong(double.parse(_lat), double.parse(_long)));
    }
  }
}

class LocationData {
  LatLong latLong;
  String state;
  LocationData(this.state, this.latLong);
}
