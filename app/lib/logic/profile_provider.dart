import 'package:app/models/user.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:flutter/widgets.dart';

class ProfileProvider extends ChangeNotifier {
  IProfileRepository profileRepository;

  User user;
}