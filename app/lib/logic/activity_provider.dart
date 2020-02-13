// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: TODO

import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';




///
///
///
class ActivityProvider extends ChangeNotifier {

   IActivityService _activityService;

   List<Activity> activities;


  ///
  ///
  ///
  ActivityProvider({
    @required IActivityService activitiesService
  }) : this._activityService = activitiesService {
    loadActivities();
    print(activities?.length);
    print("OK");
  }


  ///
  ///
  ///
  loadActivities() async {
    await Future.delayed(Duration(seconds: 2));
    this.activities = await _activityService.retreiveActivities(
      position: Position(latitude: 48.41759806, longitude: -71.04387688),
      radius: 50,
    );
    notifyListeners();
  }
}