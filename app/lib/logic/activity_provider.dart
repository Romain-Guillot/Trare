// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: TODO

import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


final defaultRadius = 50.0;



///
///
///
class ActivitiesConfig {
  double radius;
  Position position;
}




///
///
///
class ActivityProvider extends ChangeNotifier {

   IActivityService _activityService;

   final config = ActivitiesConfig();
   List<Activity> activities;


  ///
  ///
  ///
  ActivityProvider({
    @required IActivityService activitiesService
  }) : this._activityService = activitiesService {
    config.radius = defaultRadius;
    loadActivities();
  }






  ///
  ///
  ///
  loadActivities() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      config.position = position;
    } catch(e) {
      return ;
    }
    await Future.delayed(Duration(seconds: 2));
    this.activities = await _activityService.retreiveActivities(
      position: config.position,
      radius: config.radius,
    );
    notifyListeners();
  }
}