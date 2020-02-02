// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO
import 'dart:async';

import 'package:app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';


/// Repository used to get and edit the connected [User]
/// 
/// It's a very basic inteface with two actions :
///   - Get the user : [getUser()]
///   - Edit the user information : [editUser()]
/// 
/// So the goal of this repository if to get or insert data belonging to users 
/// in a remote database.
abstract class IProfileRepository {

  /// Returns the [User] currently connected to the application
  /// 
  /// The returned instance contains all information about the user (e.g : 
  /// [User.name], [User.description], etc.).
  /// 
  /// If their are no connected user, the function returned an [Future.error].
  /// 
  /// null is never returned (either the user or the error).
  Future<User> getUser();


  /// Update the connected user information with the data contained in [user]
  /// 
  /// The new updated [User] is returned
  /// The function returned an exception if an error occured (Note: it can
  /// be catch it with [Future.catchError()] when you called this function)
  /// 
  /// null is never returned (either the user or the error).
  Future<User> editUser(User user);
}



/// Implementation of [IProfileRepository] that used Cloud Firestore (Firebase)
///
/// See interface-level documentation to know more. 
/// See the corresponding specification `sprint2 > bdd_archi.md` (french)
/// 
/// Note:
/// This repository used the pattern Adapter :
/// - to adapt noSQL data ([Map]) to [User] (to get the user)
/// - to adapt [User] to noSQL data ([Map]) (to insert the user information)
/// See [_FirestoreUserAdapter]
class FiresoreProfileRepository implements IProfileRepository {
  
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;


  /// See interface-level documentation [IProfileRepository.getUser()] (specs)
  /// 
  /// Details about the implementation only :
  /// - As the cloud_firestore package returns a snapshot to get data, a 
  ///   [Completer] is used to return a future and complete the future later
  ///   (when the snapshot gives us the result)
  /// - If the user is not connected or if an error occured when completer
  ///   the future with an error
  /// - Else, we complete the future with the connected user.
  @override
  Future<User> getUser() async {
    final completer = Completer<User>();
    var userDoc = await _userDocumentRef;
    if (userDoc != null) {
      userDoc.get()
        .then((userData) {
          try {
            final user = _FirestoreUserAdapter(userData: userData?.data??{});
            completer.complete(user);
          } catch (_) {
            completer.completeError(null);
          }
        });
    } else {
      completer.completeError(null);
    }
    return completer.future;
  }


  /// See interface-level documentation [IProfileRepository.editUser()] (specs)
  /// 
  /// Details about the implementation only :
  /// 
  /// - This function use the Adapter for the two-ways adapting
  /// - The [user] paramater is first transform thanks to the 
  ///   [_FirestoreUserAdapter] to a [Map] (the noSQL data) and then this noSQL 
  ///   data is inserted into the Cloud Firestore database.
  /// - If the updating succeed, the inserted map is adapt to [User] thanks to the
  /// [_FirestoreUserAdapter] adapter and returned.
  @override
  Future<User> editUser(User user) async {
    var userDoc = await _userDocumentRef;
    if (userDoc != null) {
      var userData = _FirestoreUserAdapter.toMap(user);
      await userDoc.setData(userData).catchError((e) => print(e));
      return _FirestoreUserAdapter(userData: userData);
    } 
    return Future.error(null);
  }


  /// Get the connected user Firestore document
  /// 
  /// Return null is the user is not connected, or if we cannot retreive the 
  /// user document for any reason
  Future<DocumentReference> get _userDocumentRef async {
    final fbUser = await _auth.currentUser();
    if (fbUser != null)
      return _firestore.collection(_Identifiers.USERS_COL).document(fbUser.uid);
    return null;
  }
}



/// Adapter use to adapt [Map] (noSQL data) to [User].
///
/// So it implements User, and take a [Map] as constructor paramater
/// to build out User from the noSQL data. It allows to hide the complexity
/// of transformation.
/// 
/// It is also used to do the reverse direction transformation ([User] to SQL 
/// data) but as SQL data is respresented by a [Map<String, dynamic] it is too 
/// painful to implements [Map] as there are a lot of methods. Instead there is 
/// simply the static method [toMap] that take a [User] and return the 
/// [Map].
///
/// See https://refactoring.guru/design-patterns/adapter to know more about the
/// adapter pattern.
class _FirestoreUserAdapter implements User {
  String country;
  String description;
  String name;
  String spokenLanguages;
  String urlPhoto;
  int age;

  _FirestoreUserAdapter({@required Map<String, Object> userData}) {
    this.name = userData[_Identifiers.USER_NAME];
    this.description = userData[_Identifiers.USER_DESCRIPTION];
    this.age = userData[_Identifiers.USER_AGE];
    this.country = userData[_Identifiers.USER_LOCATION];
    this.spokenLanguages = userData[_Identifiers.USER_LANGUAGES];
    this.urlPhoto = userData[_Identifiers.USER_PHOTO];
  }

  static Map<String, Object> toMap(User user) => {
    _Identifiers.USER_NAME: user.name,
    _Identifiers.USER_DESCRIPTION: user.description,
    _Identifiers.USER_LOCATION: user.country,
    _Identifiers.USER_AGE: user.age,
    _Identifiers.USER_LANGUAGES: user.spokenLanguages,
    _Identifiers.USER_PHOTO: user.urlPhoto
  };
}



/// Identifiers (name of collections / fields) used in the Cloud Firestore
/// noSQL database.
/// 
/// See the corresponding specification `sprint2 > bdd_archi.md` (french)
class _Identifiers {
  static const USERS_COL = "users";

  static const USER_NAME = "name";
  static const USER_DESCRIPTION = "description";
  static const USER_AGE = "age";
  static const USER_LOCATION = "country";
  static const USER_LANGUAGES = "languages";
  static const USER_PHOTO = "photoURL";
}