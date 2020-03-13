import 'package:geolocator/geolocator.dart';


/// Service used to get the current user location
///
/// See [UserLocationService]
abstract class IUserLocationService {

  /// Returns the current user location, or null if we cannot determine his
  /// location
  Future<Position> retrieveUserPosition();
} 



/// Implementation of [IUserLocationService] that used the device sensors
/// 
/// It uses the geolocator package
class UserLocationService implements IUserLocationService {
  @override
  Future<Position> retrieveUserPosition() async {
    try { 
      var position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.medium
      );
      return position;
    } catch(_) {
      return null;
    }
  }
}