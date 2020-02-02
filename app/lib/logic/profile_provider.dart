import 'package:app/models/user.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:flutter/widgets.dart';


/// [ChangeNotifier] used to handle the current connected [user] 
/// 
/// [user] is the current connected user.
/// You need to initialized the provide to retreive the user. Call [loadUser()]
/// method to initialized the provider.
/// 
/// [state] is the current state of the provider, it can take the following
/// values :
/// - [ProfileProviderState.not_initialized]
/// - [ProfileProviderState.error]
/// - [ProfileProviderState.initialized]
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

  /// The current provider state (not initialized, error, initialized)
  /// 
  /// See [ProfileProviderState]
  ProfileProviderState _state = ProfileProviderState.not_initialized;
  ProfileProviderState get state => _state;
  set state(state) {
    _state = state;
    notifyListeners();
  } 
  

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
    state = ProfileProviderState.not_initialized;
    try {
      _user = await _profileRepository.getUser();
    } catch (e) {
      state = ProfileProviderState.error;
    }
    state = ProfileProviderState.initialized;
  }


  ///
  ///
  ///
  Future editUser(User newUser) {
  

  }
}



/// State enum used to represent the current state of the [ProfileProvider]
enum ProfileProviderState {
  /// Not yet initialized
  not_initialized,

  /// An error occured
  error,

  /// The provider is initialized, all processes finished
  initialized
}