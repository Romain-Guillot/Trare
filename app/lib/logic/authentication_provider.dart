
import 'package:app/models/user.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;


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

  Future<void> handleFacebookConnexion() async {
    user = await _authenticationRepository.handleFacebookConnexion();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authenticationRepository.signOut();
  }
}