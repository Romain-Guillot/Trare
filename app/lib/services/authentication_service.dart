// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
// Tests: TODO
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


/// Service used to handle authentication operations
///
/// So it contains baisc methods to sign the user with ...
///   - social media :
///     - Google [handleGoogleLogin()]
///     - Facebook [handleFacebookLogin()]
///   - an email and a password (TODO)
///     - sign in : [handleEmailSignIn()]
///     - sign up : [handleEmailSignUp()]
///
/// You can also check if the user is logged in with [userIsConnected()]
/// and sign out the user with [signOut()]
///
/// Note that the function are not "error safe". So make sure to handle error
/// when you use them. And also, error can depends on the platform service
/// used (Firebase, Amazon, custom server, etc.)
abstract class IAuthenticationService {

  /// Returns true if the user is connected
  Future<bool> userIsConnected();

  /// Engaged the Google login process and log the user in
  ///
  /// Returns true the operation succeed and the user is now logged inf
  /// Returns false if the operation was cancelled (with no error)
  /// Throw an exception if an error occured
  Future<bool> handleGoogleLogin();

  /// Engaged the Facebook login process and log the user in
  ///
  /// Returns true the operation succeed and the user is now logged inf
  /// Returns false if the operation was cancelled (with no error)
  /// Throw an exception if an error occured
  Future<bool> handleFacebookLogin();

  /// Sign out the current user
  /// 
  /// Returns true the operation succeed and the user is now logged inf
  /// Returns false if the operation was cancelled (with no error)
  /// Throw an exception if an error occured
  Future<bool> signOut();

  /// Delete the current connected user
  ///
  /// Note: It will just delete the user reference, not its data. If you
  /// want to delete its data, please configure a trigger in your database
  Future deleteUser();
}


/// Implements [IAuthenticationService] with Firebase platform
///
/// See the IAuthenticationService to know more about the specification.
class FirebaseAuthenticationService implements IAuthenticationService {

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();


  /// See [IAuthenticationService.getCurrentUser()]
  @override
  Future<bool> userIsConnected() async {
    var fbUser = await _auth.currentUser();
    return fbUser != null;
  }


  /// See [IAuthenticationService.handleFacebookLogin()]
  @override
  Future<bool> handleFacebookLogin() async {
    var facebookAuth = await _facebookLogin.logIn(['email']);

    switch (facebookAuth.status) {
      case FacebookLoginStatus.error:
        return Future.error(facebookAuth.errorMessage);

      case FacebookLoginStatus.loggedIn:
        var credential = FacebookAuthProvider.getCredential(
          accessToken: facebookAuth.accessToken.token,
        );
        await _auth.signInWithCredential(credential);
        return true;

      case FacebookLoginStatus.cancelledByUser:
      default:
        return false;
    }
  }


  /// See [IAuthenticationService.handleGoogleLogin()]
  ///
  /// Note: this method uses the package google_sign_in. It has a bug, the
  /// method [GoogleSignIn.signIn] throw an exception instead of returning
  /// null as the documentation said.
  /// Issue: https://github.com/flutter/flutter/issues/44431)
  @override
  Future<bool> handleGoogleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) // aborted
      return false;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    return true;
  }


  /// See [IAuthenticationService.signOut()]
  @override
  Future<bool> signOut() async {
    await _auth.signOut();
    return true;
  }


  /// See [IAuthenticationService.deleteUser()]
  /// 
  /// It just delete the user reference, not its data. Its data will be deleted
  /// with cloud function trigger, see `documents > feature_authentication.md`
  @override
  Future deleteUser() async {
    var fbUser = await _auth.currentUser();
    await fbUser.delete();
  }

}
