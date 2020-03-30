// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
import 'dart:async';

import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/shared/res/firebase_identifiers.dart';
import 'package:app/user/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';



/// Services used to retreive activities store in database
///
/// For now, it has only one method to query activity base on their poisition
abstract class IActivityService {

  /// Performs a geoquery to retreive activities
  /// 
  /// Returns activities within the radius defined by [radius].(from [position])
  /// null is never returned
  /// An exception can be throwed if an error occured
  Future<List<Activity>> retreiveActivities({@required Position position, @required double radius});

  /// Insert an activity in database
  /// 
  /// Returns the created activity if the insertion succeed
  /// null is never returned
  /// An exception can be throwed if an error occured
  Future <Activity> createActivity(Activity activity);

  /// Returns activities created by [user]
  /// 
  /// null is never returned (an empty list is returned if the user has never
  /// created an activity)
  /// An exception can be throwed if an error occured
  Future <List<Activity>> retreiveActivitiesUser({@required User user});
}



/// Implementation of [IActivityService] that uses Firestore noSQL database
///
/// See interface-level documentation to know more. 
/// See the corresponding specification `documents > archi_server.md` (french)
/// 
/// Note:
///   - the package `geolocator` is used to performs geo queries
class FirestoreActivityService implements IActivityService {

  final IProfileService _profileService;
  final _firestore = Firestore.instance;
  final _geo = Geoflutterfire(); // used to perform geo queries


  FirestoreActivityService({
    @required IProfileService profileService
  }) : this._profileService = profileService;
  

  /// See interface-level doc [IActivitiesService.retreiveActivities()] (specs)
  ///
  /// `geolocator` is used to perfoms to geo query thanks to the geohash store
  /// for each activity. [position] is transforms for [GeoFirePoint] and
  /// then the query is perfomed with the tranformed position and [radius]
  /// 
  /// Then, we retreive all activities data that we adapt with 
  /// [FirestoreActivityAdapter] adapter to obtain [Activity] objects.
  /// We use [Completer] to complete the future once we retreive all activities
  @override
  Future<List<Activity>> retreiveActivities({@required Position position, @required double radius}) async {
    var completer = Completer<List<Activity>>();
    StreamSubscription subscribtion;
    
    var geoPosition = _geo.point(
      latitude: position.latitude, 
      longitude: position.longitude
    );
    var activitiesCol = _firestore.collection(FBQualifiers.ACT_COL);
    subscribtion = _geo.collection(collectionRef: activitiesCol).within(
      center: geoPosition, 
      radius: radius, 
      field: FBQualifiers.ACT_LOCATION,
      strictMode: true
    ).listen((docSnaps) async {
      var activities = List<Activity>();
      for (var docSnap in docSnaps) {
        try {
          var userUID = docSnap[FBQualifiers.ACT_USER];
          if (userUID != null) {
            var user = await _profileService.getUser(userUID: userUID);
            var activity = FirestoreActivityAdapter(
              id: docSnap.documentID,
              data: docSnap.data, 
              user: user
            );
            activities.add(activity);
          }
        } catch (e) { print(e);}
      }
      completer.complete(activities);
      subscribtion.cancel();
    });
    return completer.future;
  }


  /// TODO
  ///
  ///
  @override
  Future<Activity> createActivity(Activity activity) async {
    var activityData = FirestoreActivityAdapter.toMap(activity);
    if (activityData != null) {
      var activityColRef = _firestore.collection(FBQualifiers.ACT_COL);
      var docRef = await activityColRef.add(activityData);
      return FirestoreActivityAdapter(
        id: docRef.documentID,
        data: activityData, 
        user: activity.user
      );
    }
    return Future.error(null);   
  }


  /// TODO
  ///
  ///
  @override
  Future<List<Activity>> retreiveActivitiesUser({User user}) {
    var completer = Completer<List<Activity>>();
    var activities = List<Activity>();
    var activitiesUsercollection = _firestore.collection(FBQualifiers.ACT_COL)
      .where(FBQualifiers.ACT_USER, isEqualTo: user.uid)
      .getDocuments();

    activitiesUsercollection.then((QuerySnapshot snapshot) async {
      snapshot.documents.forEach((docsnap) {
        try{
          var activity = FirestoreActivityAdapter(
            id: docsnap.documentID,
            data: docsnap.data, 
            user: user
          );
          activities.add(activity);
        } catch(_) { }
      });
      completer.complete(activities);
    });
    return completer.future;
  }
}
  



/// Adpater used to adapt noSQL data ([Map]) to [Activity]
///
/// So it implements [Activity], and take a [Map] as constructor paramater
/// to build out [Activity] from the noSQL data. It allows to hide the complexity
/// of transformation.
/// 
/// See https://refactoring.guru/design-patterns/adapter to know more about the
/// adapter pattern.
class FirestoreActivityAdapter extends Activity {

  FirestoreActivityAdapter({@required String id, @required Map<String, dynamic> data, @required User user}) {
    this.id = id;
    this.user = user;
    this.createdDate = dateFromTimestamp(data[FBQualifiers.ACT_CREATED_DATE]);
    this.title = data[FBQualifiers.ACT_TITLE];
    this.description = data[FBQualifiers.ACT_DESCRIPTION];
    this.beginDate = dateFromTimestamp(data[FBQualifiers.ACT_BEGIN_DATE]);
    this.endDate = dateFromTimestamp(data[FBQualifiers.ACT_END_DATE]);
    this.location = _buildPosition(data[FBQualifiers.ACT_LOCATION]);
  }

  DateTime dateFromTimestamp(dynamic data) {
    try {
      return (data as Timestamp).toDate();
    } catch (_) {
      return null;
    }
  }

  Position _buildPosition(dynamic data) {
    try {
      var geoPoint = data['geopoint'] as GeoPoint;
      return Position(latitude: geoPoint.latitude, longitude: geoPoint.longitude);
    } catch(_) {
      return null;
    }
  }

  static Map<String, Object> _buildGeoPosition(Position position) {
    var geo = Geoflutterfire();
    var myLocation = geo.point(latitude: position.latitude, longitude: position.longitude);
    return myLocation.data;
  }

  static Map<String, Object> toMap(Activity activity) => {
    FBQualifiers.ACT_CREATED_DATE: Timestamp.fromDate(DateTime.now()),
    FBQualifiers.ACT_TITLE: activity.title,
    FBQualifiers.ACT_USER: activity.user.uid,
    FBQualifiers.ACT_DESCRIPTION: activity.description,
    FBQualifiers.ACT_BEGIN_DATE: Timestamp.fromDate(activity.beginDate),
    FBQualifiers.ACT_END_DATE: Timestamp.fromDate(activity.endDate),
    FBQualifiers.ACT_LOCATION: FirestoreActivityAdapter._buildGeoPosition(activity.location)
  };
}