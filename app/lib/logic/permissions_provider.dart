import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';


enum PermissionState {granted, notGranted, neverAskAgain}



class PermissionsProvider extends ChangeNotifier {

  PermissionState location;

  PermissionsProvider() {
    _checkLocationPermissionStatus();
  }

  _checkLocationPermissionStatus() async {
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

  requestLocationPermission() async {
    if (location == PermissionState.neverAskAgain) {
      await PermissionHandler().openAppSettings();
    } else {
      await PermissionHandler().requestPermissions([
        PermissionGroup.location
      ]);
    }
    _checkLocationPermissionStatus();
  }

}