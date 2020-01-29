import 'package:app/models/user.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:flutter/widgets.dart';


///
///
/// The pattern Observer is used to define a subscription mecanisme to notify
/// objects when a new [user] is available.
/// The method [notfifListeners()] has to be used to notify listeners
/// 
/// See https://refactoring.guru/design-patterns/observer to know more about the
/// Observer pattern
class ProfileProvider extends ChangeNotifier {

  final IProfileRepository _profileRepository;

  /// When we modify the current user, we notify listener
  User _user;
  User get user => _user;
  void set user(User user) {
    _user = user;
    notifyListeners();
  }

  ProfileProvider({
    @required IProfileRepository profileRepo
  }) : this._profileRepository = profileRepo;


  editUser(User newUser) {

  }
}