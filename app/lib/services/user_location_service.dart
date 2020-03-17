import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as locationService;
import 'package:permission_handler/permission_handler.dart';


/// Service used to get the current user location
///
/// See [UserLocationService]
abstract class IUserLocationService {

  /// Returns the permission status (granted, disable, etc.)
  Future<PermissionStatus> getPermissionStatus();

  /// Returns the current user location, or null if we cannot determine his
  /// location
  Future<Position> retrieveUserPosition();

  /// Request the activation of the location service on the user device
  Future enableLocationServiceIfNecessary();
} 



/// Implementation of [IUserLocationService] that used the device sensors
/// 
/// It uses the geolocator package
class UserLocationService implements IUserLocationService {

  static Duration locationTimeout = Duration(seconds: 5);


  @override
  Future<PermissionStatus> getPermissionStatus() async {
    var permission = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.location
    );
    return permission;
  }

  @override
  Future enableLocationServiceIfNecessary() async {
    var serviceStatus = await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    if (serviceStatus == ServiceStatus.disabled)
      await locationService.Location().requestService();
  }

  /// A timeout timer is used to complete the future with the null value after
  /// the [locationTimeout] duration because if we do not do that, it will
  /// infinitly look for the user position
  @override
  Future<Position> retrieveUserPosition() async {
    await enableLocationServiceIfNecessary();
    var completer = Completer<Position>();
    var accuracy = LocationAccuracy.medium;
    var locationStatus = await getPermissionStatus();
    if (locationStatus != PermissionStatus.granted)
      completer.complete(null);

    Geolocator().getCurrentPosition(
      desiredAccuracy: accuracy
    ).then((value) { if (!completer.isCompleted) completer.complete(value);})
     .catchError((_) { if (!completer.isCompleted) completer.completeError(null);});
    
    Future.delayed(locationTimeout, () {
      if (!completer.isCompleted) completer.complete(null);
    });
  
    return completer.future;
  }
}