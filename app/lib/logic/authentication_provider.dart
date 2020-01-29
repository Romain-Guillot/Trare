
import 'package:app/models/user.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:flutter/widgets.dart';



/// [ChangeNotifier] used to handle the authentication business logic
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
/// To init the provider (so to check if an user is connected) call the [init()]
/// method.
/// 
/// The following methods can be used to authenticate an user :
///   - [handleGoogleLogin()]
///   - [handleFacebookLogin()]
/// If an error occured, it can be catched thanks to [Future.catchError()] 
/// method.
/// 
/// When these state variables change, clients are notified.
class AuthenticationProvider extends ChangeNotifier {

  final AuthenticationRepository _authRepo;
  bool _inProcess = false;
  User _user;
  bool _isInitialized;

  User get user => _user;
  set user(User user) {
    _user = user;
    notifyListeners();
  }
  
  bool get isInitialized => _isInitialized??false;
  set isInitialized(bool b) {
    _isInitialized = b;
    notifyListeners();
  }


  AuthenticationProvider({
    @required AuthenticationRepository authRepo
  }) : this._authRepo = authRepo;



  /// Check is an user is logged in the app
  /// When the init process is done, the flag [isInitialized] is set to true
  init() async {
    user = await _authRepo.getCurrentUser();
    await Future.delayed(Duration(seconds: 1)); // TODO
    print(user);
    isInitialized = true;
  }


  /// Handle the Google login
  /// Please see the class level documentation to know more about its behavior
  Future<void> handleGoogleLogin() async {
    return _handleLogin(_authRepo.handleGoogleLogin);
  }


  /// Handle Facebook login
  /// Please see the class level documentation to know more about its behavior
  Future<void> handleFacebookLogin() async {
    return _handleLogin(_authRepo.handleFacebookLogin);
  }


  /// Method to start an authentication process.
  /// 
  /// This method ensures that only ONE auhtentication process can be executed
  /// simultaneously ([_inProgress]).
  /// Return a [Future.error] if an error occured.
  Future _handleLogin(Future<User> Function() function) async {
    if (_inProcess) return ;
    bool error = false;
    _inProcess = true;
    try {
      user = await function();
    } catch (e) {
      error = true;
    }
    _inProcess = false;
    if (error) return Future.error(null);
  }


  /// Sign out the user, after the completion, the [user] propertie is set to 
  /// null pointer.
  Future<void> signOut() async {
    await _authRepo.signOut();
    user = null;
  }
}