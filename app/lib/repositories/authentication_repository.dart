
import 'package:app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


/// Repository interface to handle authentication operations
///
/// So it contains baisc methods to sign the user with ...
///   - social media :
///     - Google [handleGoogleLogin()]
///     - Facebook [handleFacebookLogin()]
///   - an email and a password
///     - sign in : [handleEmailSignIn()]
///     - sign up : [handleEmailSignUp()]
/// 
/// You can also get the current logged user (if any) with [getCurrentUser()]
/// and sign out the user with [signOut()]
/// 
/// Note that the function are not "error safe". So make sure to handle error
/// when you use them. And also, error can depends on the platform service
/// used (Firebase, Amazon, custom server, etc.)
abstract class AuthenticationRepository {

  /// Returns the current logged user
  /// Returns null is no user is connected
  Future<User> getCurrentUser();


  /// Engaged the Google login process and log the user in
  /// 
  /// Returns the current logged user is success
  /// Throw an exception if an error occured
  /// Returns null if the process has been stopped (without error)
  Future<User> handleGoogleLogin();


  /// Engaged the Facebook login process and log the user in
  /// 
  /// Returns the current logged user is success
  /// Throw an exception if an error occured
  /// Returns null if the process has been stopped (without error)
  Future<User> handleFacebookLogin();


  /// Engaged the standart email login process
  /// 
  /// [email] and [password] are used to authenticate the user.
  /// 
  /// Returns the current logged user is success
  /// Throw an exception if an error occured
  /// Returns null if the process has been stopped (without error)
  Future<User> handleEmailSignIn({String email, String password});


  /// Engaged the Google registration process and log the user in
  /// 
  /// [email] and [password] are used to create a new account
  /// 
  /// Returns the current logged user is success
  /// Throw an exception if an error occured
  /// Returns null if the process has been stopped (without error)
  Future<User> handleEmailSignUp({String email, String password});


  /// Sign out the current user, returns nothing.
  Future<void> signOut();
}



/// Implements [AuthenticationRepository] with Firebase platform
///
/// See the AuthenticationRepository to know more about the specification.
class FirebaseAuthenticationRepository implements AuthenticationRepository {
  
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();


  /// See [AuthenticationRepository.getCurrentUser()]
  @override
  Future<User> getCurrentUser() async {
    final fbUser = await _auth.currentUser();
    return fbUser == null ? null :  _FirebaseUserAdapter(user: fbUser);
  }


  /// See [AuthenticationRepository.handleEmailSignIn()]
  @override
  Future<User> handleEmailSignIn({String email, String password}) {
    throw UnimplementedError();
  }


  /// See [AuthenticationRepository.handleEmailSignUp()]
  @override
  Future<User> handleEmailSignUp({String email, String password}) {
    throw UnimplementedError();
  }


  /// See [AuthenticationRepository.handleFacebookLogin()]
  @override
  Future<User> handleFacebookLogin() async {
    final facebookAuth = await _facebookLogin.logIn(['email']);

    switch(facebookAuth.status){
      case FacebookLoginStatus.error:
        throw Exception(facebookAuth.errorMessage);

      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
          accessToken: facebookAuth.accessToken.token,
        );

        final authResult = await _auth.signInWithCredential(credential);
        final fbUser = authResult.user;
        return _FirebaseUserAdapter(user: fbUser);
        
      case FacebookLoginStatus.cancelledByUser:
      default:
        return null;
    }
  }


  /// See [AuthenticationRepository.handleGoogleLogin()]
  /// 
  /// Note: this method uses the package google_sign_in. It has a bug, the
  /// method [GoogleSignIn.signIn] throw an exception instead of returning
  /// null as the documentation said.
  /// Issue: https://github.com/flutter/flutter/issues/44431)
  @override
  Future<User> handleGoogleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) // aborted
      return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    final fbUser = authResult.user;
    
    return _FirebaseUserAdapter(user: fbUser);
  }


  /// See [AuthenticationRepository.signOut()]
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}


/// Adapter use to adapt [FirebaseUser] to [User].
/// 
/// So it implements User, and take a FirebaseUser as constructor paramater
/// to build out User from the FirebaseUser. It allows to hide the complexity
/// of transformation.
/// 
/// See https://refactoring.guru/design-patterns/adapter to know more about the
/// adapter pattern.
class _FirebaseUserAdapter implements User {
  String name;

  _FirebaseUserAdapter({@required FirebaseUser user}) {
    this.name = user.displayName;
  }
}