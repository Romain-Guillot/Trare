// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
import 'dart:async';

import 'package:app/models/user.dart';
import 'package:app/services/firebase_identifiers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';


/// Service used to get and edit the connected [User]
/// 
/// It's a very basic inteface with two actions :
///   - Get the user : [getUser()]
///   - Edit the user information : [editUser()]
/// 
/// So the goal of this service if to get or insert data belonging to users 
/// in a remote database.
abstract class IProfileService {

  /// Returns the [User] currently connected to the application
  /// 
  /// The returned instance contains all information about the user (e.g : 
  /// [User.name], [User.description], etc.).
  /// 
  /// If their are no connected user, the function returned an [Future.error].
  /// 
  /// null is never returned (either the user or the error).
  Future<User> getUser({String userUID});


  /// Update the connected user information with the data contained in [user]
  /// 
  /// The new updated [User] is returned
  /// The function returned an exception if an error occured (Note: it can
  /// be catch it with [Future.catchError()] when you called this function)
  /// 
  /// null is never returned (either the user or the error).
  Future<User> editUser(User user);
}



/// Implementation of [IProfileService] that uses Cloud Firestore (Firebase)
///
/// See interface-level documentation to know more. 
/// See the corresponding specification `documents > archi_server.md` (french)
/// 
/// Note:
/// This service used the pattern Adapter :
/// - to adapt noSQL data ([Map]) to [User] (to get the user)
/// - to adapt [User] to noSQL data ([Map]) (to insert the user information)
/// See [FirestoreUserAdapter]
class FirestoreProfileService implements IProfileService {
  
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;


  /// See interface-level documentation [IProfileService.getUser()] (specs)
  /// 
  /// Details about the implementation only :
  /// - As the cloud_firestore package returns a snapshot to get data, a 
  ///   [Completer] is used to return a future and complete the future later
  ///   (when the snapshot gives us the result)
  /// - If the user is not connected or if an error occured when completer
  ///   the future with an error
  /// - Else, we complete the future with the connected user.
  @override
  Future<User> getUser({String userUID}) async {
    final completer = Completer<User>();
    var userDoc = await _userDocumentRef(userUID);
    if (userDoc != null) {
      userDoc.get()
        .then((userData) {
          try {
            final user = FirestoreUserAdapter(
              uid: userDoc.documentID, 
              userData: userData?.data
            );
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


  /// See interface-level documentation [IProfileService.editUser()] (specs)
  /// 
  /// Details about the implementation only :
  /// 
  /// - This function use the Adapter for the two-ways adapting
  /// - The [user] paramater is first transform thanks to the 
  ///   [FirestoreUserAdapter] to a [Map] (the noSQL data) and then this noSQL 
  ///   data is inserted into the Cloud Firestore database.
  /// - If the updating succeed, the inserted map is adapt to [User] thanks to the
  /// [FirestoreUserAdapter] adapter and returned.
  @override
  Future<User> editUser(User user) async {
    var userDoc = await _userDocumentRef(null);
    if (userDoc != null) {
      var userData = FirestoreUserAdapter.toMap(user);
      await userDoc.setData(userData, merge: true);
      return FirestoreUserAdapter(uid: userDoc.documentID, userData: userData);
    } 
    return Future.error(null);
  }


  /// Get the document of the user [uid], or of the connected user if [uid] is null
  /// 
  /// Return null is [uid] is null AND the user is not connected, 
  /// or if we cannot retreive the user document for any reason
  Future<DocumentReference> _userDocumentRef(String uid) async {
    if (uid == null) {
      final fbUser = await _auth.currentUser();
      uid = fbUser?.uid;
    }
    if (uid != null)
      return _firestore.collection(FBQualifiers.USE_COL).document(uid);
    return null;
  }
}



/// Adapter used to adapt [Map] (noSQL data) to [User].
///
/// So it implements User, and take a [Map] as constructor paramater
/// to build our User from the noSQL data. It allows to hide the complexity
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
@visibleForTesting
class FirestoreUserAdapter implements User {
  String uid;
  String country;
  String description;
  String name;
  String spokenLanguages;
  String urlPhoto;
  int age;

  FirestoreUserAdapter({@required String uid, @required Map<String, Object> userData}) {
    if (userData != null) {
      this.uid = uid;
      this.name = userData[FBQualifiers.USE_NAME];
      this.description = userData[FBQualifiers.USE_DESCRIPTION];
      this.country = userData[FBQualifiers.USE_LOCATION];
      this.spokenLanguages = userData[FBQualifiers.USE_LANGUAGES];
      this.urlPhoto = userData[FBQualifiers.USE_PHOTO];
      this.age = userData[FBQualifiers.USE_AGE];
    } else {
      throw Exception();
    }
  }

  static Map<String, Object> toMap(User user) => {
    FBQualifiers.USE_NAME: user.name,
    FBQualifiers.USE_DESCRIPTION: user.description,
    FBQualifiers.USE_LOCATION: user.country,
    FBQualifiers.USE_AGE: user.age,
    FBQualifiers.USE_LANGUAGES: user.spokenLanguages,
    FBQualifiers.USE_PHOTO: user.urlPhoto
  };
}