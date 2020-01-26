
import 'package:app/models/user.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:flutter/widgets.dart';



/// Provider used to handle the authentication business logic of the app.
/// 
/// It is a [ChangeNotifier] so it can notify client when changment occured.
/// In particular this provider holds 2 public variables (the state) :
///   - [isInitialized]: false until the provider is initialized (==> until
///     the provider has checked is the user is logged or not) ;
///   - [user]: the connected user
/// 
/// [isInitialized] cannot be null.
/// [user] is null is the user is not connected (or if the provider is not yet
/// initialized).
/// 
/// When these variables change, clients are notified.
class AuthenticationProvider extends ChangeNotifier {

  final AuthenticationRepository _authRepo;

  User _user;
  User get user => _user;
  set user(User user) {
    _user = user;
    notifyListeners();
  }
  
  bool _isInitialized;
  bool get isInitialized => _isInitialized??false;
  set isInitialized(bool b) {
    _isInitialized = b;
    notifyListeners();
  }

  

  AuthenticationProvider({
    @required AuthenticationRepository authRepo
  }) : this._authRepo = authRepo;


  init() async {
    user = await _authRepo.getCurrentUser();
    await Future.delayed(Duration(seconds: 1)); // TODO
    isInitialized = true;
  }


  Future<void> handleGoogleConnexion() async {
    user = await _authRepo.handleGoogleConnexion();
  }

  Future<void> handleFacebookConnexion() async {
    user = await _authRepo.handleFacebookConnexion();
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    user = null;
  }
}