// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO

import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ActivityProvider extends ChangeNotifier {

   IActivitiesService _activityService;

   List<Activity> activities;


  ActivityProvider({
    @required IActivitiesService activitiesService
  }) : this._activityService = activitiesService {
    loadActivities();
  }


  loadActivities() async {
    this.activities = await _activityService.getActivities(
      position: Position(latitude: 48.41759806, longitude: -71.04387688),
      radius: 50,
    );
    notifyListeners();
  }
}