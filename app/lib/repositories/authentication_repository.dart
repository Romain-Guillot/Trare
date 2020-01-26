
import 'package:app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';



abstract class AuthenticationRepository {

  Future<User> getCurrentUser();

  Future<User> handleGoogleConnexion();

  Future<User> handleFacebookConnexion();

  Future<User> handleEmailSignIn();

  Future<User> handleEmailSignUp();

  Future<void> signOut();
}


class FirebaseAuthenticationRepository implements AuthenticationRepository {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();


  @override
  Future<User> getCurrentUser() async {
    FirebaseUser fbUser = await _auth.currentUser();
    return fbUser == null ? null :  _FirebaseUserAdapter(user: fbUser);
  }

  @override
  Future<User> handleEmailSignIn() {
    throw UnimplementedError();
  }

  @override
  Future<User> handleEmailSignUp() {
    throw UnimplementedError();
  }

  @override
  Future<User> handleFacebookConnexion() async {
    FacebookLoginResult facebookAuth = await facebookLogin.logIn(['email']);

    switch(facebookAuth.status){
      case FacebookLoginStatus.loggedIn:
        break;
      case FacebookLoginStatus.error:
        print(facebookAuth.errorMessage);
        return null;
      case FacebookLoginStatus.cancelledByUser:
        return null;
    }

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: facebookAuth.accessToken.token,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser fbUser = authResult.user;
    return _FirebaseUserAdapter(user: fbUser);
  }


  @override
  Future<User> handleGoogleConnexion() async {
    
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser fbUser = authResult.user;
      
      return _FirebaseUserAdapter(user: fbUser);
  }


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