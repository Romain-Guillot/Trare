// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO
import 'dart:async';

import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';


abstract class IActivitiesService {
  Future<List<Activity>> getActivities({@required Position position, @required double radius});
}


class FirestoreActivitiesService implements IActivitiesService {

  final _firestore = Firestore.instance;
  final geo = Geoflutterfire();
  

  @override
  Future<List<Activity>> getActivities({@required Position position, @required double radius}) async {
    var completer = Completer<List<Activity>>();
    StreamSubscription subscribtion;
    
    var geoPosition = geo.point(
      latitude: position.latitude, 
      longitude: position.longitude
    );
    var activitiesCol = _firestore.collection(_Identifiers.ACTIVITIES_COL);
    subscribtion = geo.collection(collectionRef: activitiesCol).within(
      center: geoPosition, 
      radius: radius, 
      field: _Identifiers.ACTIVITY_LOCATION,
      strictMode: true
    ).listen((docSnaps) {
      var activities = List<Activity>();
      for (var docSnap in docSnaps) {
        var activity = _FirestoreActivityAdapter(data: docSnap.data);
        activities.add(activity);
      }
      completer.complete(activities);
      subscribtion.cancel();
    });
    return completer.future;
  }
}


class _FirestoreActivityAdapter implements Activity {
  
  @override DateTime createdDate;
  @override String title;
  @override User user;
  @override String description;
  @override DateTime beginDate;
  @override DateTime endDate;
  @override Position location;


  _FirestoreActivityAdapter({@required Map<String, dynamic> data}) {
    createdDate = data[_Identifiers.ACTIVITY_CREATED_DATE];
    title = data[_Identifiers.ACTIVITY_TITLE];
    user = data[_Identifiers.ACTIVITY_USER];
    description = data[_Identifiers.ACTIVITY_DESCRIPTION];
    beginDate = data[_Identifiers.ACTIVITY_BEGIN_DATE];
    endDate = data[_Identifiers.ACTIVITY_END_DATE];
    location = buildPosition(data[_Identifiers.ACTIVITY_LOCATION]);
  }

  Position buildPosition(dynamic data) {
    try {
      var geoPoint = data["geopoint"] as GeoPoint;
      return Position(latitude: geoPoint.latitude, longitude: geoPoint.longitude);
    } catch(_) {
      return null;
    }
  }
}

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