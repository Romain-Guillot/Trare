import 'package:app/services/user_location_service.dart';
import 'package:geolocator/geolocator.dart';

class MockLocationService implements IUserLocationService {
  @override
  Future<Position> retrieveUserPosition() async {
    return Position(latitude: 0, longitude: 0);
  }

}