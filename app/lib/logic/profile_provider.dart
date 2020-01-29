import 'package:app/models/user.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:flutter/widgets.dart';


/// [ChangeNotifier] used to handle the current connected [user] 
/// 
/// [user] is the current connected user.
/// To edit the current connected user used the method [editUser].
/// The listeners will be automatically notify with the new connected [user].
/// 
/// The pattern Observer is used to define a subscription mecanisme to notify
/// objects when a new [user] is available.
/// The method [notfifListeners()] has to be used to notify listeners
/// 
/// See https://refactoring.guru/design-patterns/observer to know more about the
/// Observer pattern
class ProfileProvider extends ChangeNotifier {

  /// Repository used to perform action on the user (get, edit)
  final IProfileRepository _profileRepository;

  bool isInit = false;
  bool error = false;

  /// When we modify the current user, we notify listener
  User _user;
  User get user => _user;
  set user(User user) {
    _user = user;
    notifyListeners();
  }

  ProfileProvider({
    @required IProfileRepository profileRepo
  }) : this._profileRepository = profileRepo;


  Future loadUser() async {
    error = false;
    isInit = false;
    try {
      _user = await _profileRepository.getUser();
      print("SUCCESS");
    } catch (e) {
      print("ERROR");
      error = true;
    }
    isInit = true;
    notifyListeners();
  }

  ///
  ///
  ///
  Future editUser(User newUser) {

  }
}