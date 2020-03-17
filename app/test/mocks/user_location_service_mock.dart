import 'package:app/services/user_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class MockLocationService implements IUserLocationService {

  bool willReturnError = false;

  Position position = Position(latitude: 0, longitude: 0);

  @override
  Future<Position> retrieveUserPosition() async {
    if (willReturnError)
      return null;
    return position;
  }

  @override
  Future<PermissionStatus> getPermissionStatus() {
    // TODO: implement getPermissionStatus
    throw UnimplementedError();
  }

  @override
  Future enableLocationServiceIfNecessary() {
    // TODO: implement enableLocationServiceIfNecessary
    throw UnimplementedError();
  }

}