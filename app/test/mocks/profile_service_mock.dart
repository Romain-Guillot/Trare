// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/models/user.dart';
import 'package:app/services/profile_service.dart';

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