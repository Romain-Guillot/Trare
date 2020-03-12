// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
// Tests: TODO
import 'dart:async';

import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/profile_service.dart';
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

  /// insert the activity created by the user in the firestore
  /// 
  /// 
  Future <Activity> createActivity(Activity activity);

  /// Returns activities created by [user]
  /// Returns null if the current [user] has never create an [activity]
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
  /// [_FirestoreActivityAdapter] adapter to obtain [Activity] objects.
  /// We use [Completer] to complete the future once we retreive all activities
  @override
  Future<List<Activity>> retreiveActivities({@required Position position, @required double radius}) async {
    var completer = Completer<List<Activity>>();
    StreamSubscription subscribtion;
    
    var geoPosition = _geo.point(
      latitude: position.latitude, 
      longitude: position.longitude
    );
    var activitiesCol = _firestore.collection(_Identifiers.ACTIVITIES_COL);
    subscribtion = _geo.collection(collectionRef: activitiesCol).within(
      center: geoPosition, 
      radius: radius, 
      field: _Identifiers.ACTIVITY_LOCATION,
      strictMode: true
    ).listen((docSnaps) async {
      var activities = List<Activity>();
      for (var docSnap in docSnaps) {
        try {
          var userUID = docSnap[_Identifiers.ACTIVITY_USER];
          if (userUID != null) {
            var user = await _profileService.getUser(userUID: userUID);
            var activity = _FirestoreActivityAdapter(data: docSnap.data, user: user);
            activities.add(activity);
          }
        } catch (e) { print(e);}
      }
      completer.complete(activities);
      subscribtion.cancel();
    });
    return completer.future;
  }


  ///
  ///
  ///
  @override
  Future<Activity> createActivity(Activity activity) async {
    var activityData = _FirestoreActivityAdapter.toMap(activity);
    if (activityData != null) {
      var activityDoc = _firestore.collection(_Identifiers.ACTIVITIES_COL);
      await activityDoc.add(activityData);
      return _FirestoreActivityAdapter(data: activityData, user: activity.user);
    }
    return Future.error(null);   
  }

  @override
  Future<List<Activity>> retreiveActivitiesUser({User user}) {
   var completer = Completer<List<Activity>>();
   var activities = List<Activity>();
   var activitiesUsercollection = _firestore.collection(_Identifiers.ACTIVITIES_COL)
   .where("user" == user.uid)
   .getDocuments();
   
   activitiesUsercollection.then((QuerySnapshot snapshot) async {
     try{
       snapshot.documents.forEach((docsnap) {
         var activity = _FirestoreActivityAdapter(data: docsnap.data, user: user);
         activities.add(activity);
        });
     } catch(e){
       print(e);
     }
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
class _FirestoreActivityAdapter implements Activity {
  
  @override DateTime createdDate;
  @override String title;
  @override User user;
  @override String description;
  @override DateTime beginDate;
  @override DateTime endDate;
  @override Position location;

  _FirestoreActivityAdapter({@required Map<String, dynamic> data, @required User user}) {
    this.createdDate = dateFromTimestamp(data[_Identifiers.ACTIVITY_CREATED_DATE]);
    this.title = data[_Identifiers.ACTIVITY_TITLE];
    this.user = user;
    this.description = data[_Identifiers.ACTIVITY_DESCRIPTION];
    this.beginDate = dateFromTimestamp(data[_Identifiers.ACTIVITY_BEGIN_DATE]);
    this.endDate = dateFromTimestamp(data[_Identifiers.ACTIVITY_END_DATE]);
    this.location = _buildPosition(data[_Identifiers.ACTIVITY_LOCATION]);
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
    _Identifiers.ACTIVITY_CREATED_DATE: Timestamp.fromDate(DateTime.now()),
    _Identifiers.ACTIVITY_TITLE: activity.title,
    _Identifiers.ACTIVITY_USER: activity.user.uid,
    _Identifiers.ACTIVITY_DESCRIPTION: activity.description,
    _Identifiers.ACTIVITY_BEGIN_DATE: Timestamp.fromDate(activity.beginDate),
    _Identifiers.ACTIVITY_END_DATE: Timestamp.fromDate(activity.endDate),
    _Identifiers.ACTIVITY_LOCATION: _FirestoreActivityAdapter._buildGeoPosition(activity.location)
  };
}



/// Identifiers (name of collections / fields) used in the Cloud Firestore
/// noSQL database to store activities
/// 
/// See the corresponding specification `documents > archi_server.md` (french)
class _Identifiers {
  static const ACTIVITIES_COL = "activities";

  static const ACTIVITY_CREATED_DATE = "createdDate";
  static const ACTIVITY_TITLE = "title";
  static const ACTIVITY_USER = "user";
  static const ACTIVITY_DESCRIPTION = "description";
  static const ACTIVITY_BEGIN_DATE = "beginDate";
  static const ACTIVITY_END_DATE = "endDate";
  static const ACTIVITY_LOCATION = "location";
}