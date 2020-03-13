import 'package:geolocator/geolocator.dart';

abstract class IUserLocationService {
  /// Returns the current user location, or null if we cannot determine his
  /// location
  Future<Position> retrieveUserPosition();
} 

class UserLocationService implements IUserLocationService {
  @override
  Future<Position> retrieveUserPosition() async {
    try { // getCurrentPosition can throw an exception the location permission is not granted
      var position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.medium
      );
      return position;
    } catch(_) {
      return null;
    }
  }

}