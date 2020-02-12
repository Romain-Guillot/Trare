// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
// Tests: TODO
import 'package:app/services/authentication_service.dart';
import 'package:flutter/widgets.dart';


/// Represents the authentication provider state
enum AuthProviderState {
  inprogress,
  connected,
  notconnected,
  error,
}



/// [ChangeNotifier] used to handle the authentication business logic
/// 
/// It is a [ChangeNotifier] so it can notify client when changement occured.
/// It holds an [AuthProviderState] state :
///   - connected
///   - not connected
///   - error: an error occured during authentication operation
///   - inprogress: an authentication operation is in progress
/// 
/// To init the provider (so to check if an user is connected) call the [init()]
/// method.
/// 
/// The following methods can be used to authenticate an user :
///   - [handleGoogleLogin()]
///   - [handleFacebookLogin()]
/// [signOut()] can be used to sign out the current connected user.
/// 
/// If an error occured, it can be catched thanks to [Future.catchError()] 
/// method or through the provider [state].
/// 
/// When the state changed, client are notified
class AuthenticationProvider extends ChangeNotifier {

  final IAuthenticationService _authService;

  var _state = AuthProviderState.notconnected;
  AuthProviderState get state => _state;
  set state(state) {
    _state = state;
    notifyListeners();
  } 

  bool get isConnected => _state == AuthProviderState.connected; 


  AuthenticationProvider({
    @required IAuthenticationService authService
  }) : this._authService = authService;


  /// Check is an user is logged in the app and update the provider state
  init() async {
    state = AuthProviderState.inprogress;
    var connected = await _authService.userIsConnected();
    state = connected ? AuthProviderState.connected : AuthProviderState.notconnected;
  }


  /// Handle the Google login and update the provider state
  Future handleGoogleLogin() async {
    return _handleLogin(_authService.handleGoogleLogin);
  }


  /// Handle Facebook login and update the provider state
  Future handleFacebookLogin() async {
    return _handleLogin(_authService.handleFacebookLogin);
  }


  /// Sign out the user and update the state
  Future signOut() async {
    await _authService.signOut();
    state = AuthProviderState.notconnected;
  }


  /// Method to start an authentication operation and update the state.
  /// 
  /// This method ensures that only ONE auhtentication process can be executed
  /// simultaneously (else, error can occured with Facebook log in).
  /// 
  /// Udate the state depending on the result (conneted, error, etc.)
  /// Return a [Future.error] if an error occured.
  Future _handleLogin(Future<bool> Function() connexionFunction) async {
    if (state == AuthProviderState.inprogress) 
      return ;

    state = AuthProviderState.inprogress;
    try {
       var connected = await connexionFunction();
       state = connected ? AuthProviderState.connected : AuthProviderState.notconnected;
       return ;
    } catch (e) {
      state = AuthProviderState.error;
      return Future.error(null);
    }
  }
}