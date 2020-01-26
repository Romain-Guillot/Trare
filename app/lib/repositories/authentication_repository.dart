
import 'package:app/logic/authentication_provider.dart';
import 'package:app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

abstract class AuthenticationRepository {

  Future<User> getCurrentUser();

  Future<User> handleGoogleConnexion();

  Future<User> handleFacebookConnexion();

  Future<User> handleEmailSignIn();

  Future<User> handleEmailSignUp();

  Future<void> signOut();
}


class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin=FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User> getCurrentUser() async {
    FirebaseUser fbUser = await _auth.currentUser();
    if (fbUser == null) return null;
    else return _firebaseUserToUser(fbUser);
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
    final facebookLogin=FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch(result.status){
      case FacebookLoginStatus.loggedIn:
          print("Connexion reussie");
          //isInitialized=tue
          
        break;
      case FacebookLoginStatus.error:
          print("Erreur de connexion");
          //isInitialized=false
        break;
      case FacebookLoginStatus.cancelledByUser:
          print("Connexion annulée par l'user");
    }

    //final FirebaseUser user = authResult.user;
    //return _firebaseUserToUser(user);
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
    final FirebaseUser user = authResult.user;
    
    return _firebaseUserToUser(user);
  }

  User _firebaseUserToUser(FirebaseUser fbUser) {
    return User(name: fbUser.displayName);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

}