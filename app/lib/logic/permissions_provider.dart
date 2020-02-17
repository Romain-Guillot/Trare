// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
// Tests: TODO
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';


/// Represents a permission state
enum PermissionState {granted, notGranted, neverAskAgain}



/// Used to handle the location permission
///
/// In particular the current location permissation state is accessible with
/// the [location] propertie.
/// 
/// You can try to grant the location permission with [requestLocationPermission]
/// Two cases are possible :
///   - the permission state is neverAskAgain, the app settings page will be
///   open to let the user manually checked the permission
///   - else, the traditionnal permission pop-up will be dispalyed to let
///   the user allow (et denied) the permission
class LocationPermissionProvider extends ChangeNotifier {

  PermissionState location;


  LocationPermissionProvider() {
    _checkLocationPermissionStatus();
  }


  /// Check if the location permission is granted. Update the [location] state
  /// and notify clients
  Future _checkLocationPermissionStatus() async {
    var permission = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.location
    );
    switch (permission) {
      case PermissionStatus.granted:
        location = PermissionState.granted;
        break;
      case PermissionStatus.denied:
      case PermissionStatus.unknown:
        location = PermissionState.notGranted;
        break;
      default:
        location = PermissionState.neverAskAgain;
    }
    print(location);
    notifyListeners();
  }


  /// Try to grant the location permission
  ///
  /// Two cases are possible :
  ///   - the permission state is neverAskAgain, the app settings page will be
  ///   open to let the user manually checked the permission
  ///   - else, the traditionnal permission pop-up will be dispalyed to let
  ///   the user allow (et denied) the permission
  /// 
  /// After this, the location permission will be verified again (and clients
  /// will be notified)
  Future requestLocationPermission() async {
    if (location == PermissionState.neverAskAgain) {
      await PermissionHandler().openAppSettings();
    } else {
      await PermissionHandler().requestPermissions([
        PermissionGroup.location
      ]);
    }
    await _checkLocationPermissionStatus();
  }
}