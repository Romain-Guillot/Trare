
import 'package:app/models/user.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:flutter/widgets.dart';


class AuthenticationProvider extends ChangeNotifier {

  User user;
  bool isInitialized = false;

  AuthenticationRepository _authenticationRepository;

  AuthenticationProvider({@required AuthenticationRepository authenticationRepository}) {
    this._authenticationRepository = authenticationRepository;
    _checkIfUserLogged();
  }

  _checkIfUserLogged() async {
    user = await _authenticationRepository.getCurrentUser();
    await Future.delayed(Duration(seconds: 1)); // TODO
    isInitialized = true;
    notifyListeners();
  }


  Future<void> handleGoogleConnexion() async {
    user = await _authenticationRepository.handleGoogleConnexion();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authenticationRepository.signOut();
  }
}