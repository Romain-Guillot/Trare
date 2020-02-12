// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO
import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';


abstract class IActivitiesRepository{
  Future<List<Activity>> getActivities();
}


class FirestoreActivitiesRepository implements IActivitiesRepository {

  @override
  Future<List<Activity>> getActivities() async {
    await Future.delayed(Duration(seconds: 3));
    return [];
  }
}


class _FirestoreActivityAdapter implements Activity {
  
  @override DateTime beginDate;
  @override DateTime createdDate;
  @override String description;
  @override DateTime endDate;
  @override Position location;
  @override String title;
  @override User user;

  _FirestoreActivityAdapter({@required Map<String, dynamic> data}) {
    
  }
}

class _Identifiers {
  static const ACTIVITIES_COL = "activities";

  static const ACTIVITY_TITLE = "title";
  static const ACTIVITY_USER = "user";

}