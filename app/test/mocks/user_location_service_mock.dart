import 'package:app/services/user_location_service.dart';
import 'package:geolocator/geolocator.dart';

class MockLocationService implements IUserLocationService {

  bool willReturnError = false;

  Position position = Position(latitude: 0, longitude: 0);

  @override
  Future<Position> retrieveUserPosition() async {
    if (willReturnError)
      return null;
    return position;
  }

}