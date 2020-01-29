import 'package:app/models/user.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:flutter/widgets.dart';


/// [ChangeNotifier] used to handle the current connected [user] 
/// 
/// [user] is the current connected user.
/// You need to initialized the provide to retreive the user. Call [loadUser()]
/// method to initialized the provider.
/// 
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

  /// Flag to indicate whether the provider has been initialized or not
  /// Use [loadUser()] to initialize the provider
  bool _isInit = false;
  bool get isInit => _isInit;
  
  /// Flag to indicate that an error occured to retrieve the current connected
  /// user
  bool _error = false;
  bool get error => _error;

  /// The current connected user. Can be null for many reason (you can check the
  /// current state with the flags [isInit] and [error])
  User _user;
  User get user => _user;


  ProfileProvider({
    @required IProfileRepository profileRepo
  }) : this._profileRepository = profileRepo;

  /// 
  ///
  Future loadUser() async {
    _error = false;
    _isInit = false;
    try {
      _user = await _profileRepository.getUser();
    } catch (e) {
      _error = true;
    }
    _isInit = true;
    notifyListeners();
  }

  ///
  ///
  ///
  Future editUser(User newUser) {

  }
}