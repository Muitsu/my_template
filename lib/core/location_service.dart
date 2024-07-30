import 'package:location/location.dart';
import 'dart:developer' as dev;
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  //Singleton
  static final LocationService instance = LocationService._init();
  factory LocationService() => instance;
  LocationService._init();

  //Variables
  late bool hasPermission;
  double latitude = 5.389450;
  double longitude = 100.563431;
  DateTime? lastUpdateDT;

  Future<void> getCurrentLocation() async {
    Location location = Location();
    var permissionStatus = await location.hasPermission();

    if (!_isPermissionGranted(permissionStatus)) {
      permissionStatus = await location.requestPermission();
      hasPermission = _isPermissionGranted(permissionStatus);
      if (!hasPermission) return;
    }
    if (lastUpdateDT != null) {
      if (DateTime.now().difference(lastUpdateDT!).inMinutes < 1) {
        dev.log("Please wait 1 minute to update location", name: "LOCATION");
        return;
      }
    } else {
      lastUpdateDT = DateTime.now();
    }
    await location.getLocation().then((location) {
      latitude = location.latitude ?? 5.389450;
      longitude = location.longitude ?? 100.563431;
    }).catchError((e) {
      dev.log(e, name: "LOCATION");
    });
    await getLocationAddress();
    lastUpdateDT = DateTime.now();
  }

  Future<void> getLocationAddress() async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      // final data = placemarks[0].toString();
      dev.log("Fetch address succesful", name: "LOCATION");
    }
  }

  bool canRefreshLocation() {
    if (lastUpdateDT == null) {
      dev.log("Maybe location not initialize", name: "LOCATION");
      return false;
    }
    bool canRefresh = (DateTime.now().difference(lastUpdateDT!).inMinutes >= 1);
    dev.log("Can refresh: $canRefresh", name: "LOCATION");
    return canRefresh;
  }

  bool _isPermissionGranted(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.granted;

  Future<bool> checkHasPermission() async {
    Location location = Location();
    var permissionStatus = await location.hasPermission();
    return permissionStatus == PermissionStatus.granted ? true : false;
  }
}
