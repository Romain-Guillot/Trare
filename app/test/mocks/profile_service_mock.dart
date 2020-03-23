import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';

import 'shared_models.dart';


class MockProfileService implements IProfileService {  

  bool willReturnError = false;

  @override
  Future<User> editUser(User user)
  => throw UnimplementedError();

  @override
  Future<User> getUser({String userUID}) async {
    if (willReturnError)
      throw Exception();
    return user;
  }
}