// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO

import 'package:app/models/activity.dart';
import 'package:app/repositories/activity_repository.dart';
import 'package:flutter/cupertino.dart';

class ActivityProvider extends ChangeNotifier {

   IActivitiesRepository _activityRepository;

   List<Activity> activities;


  ActivityProvider({
    @required IActivitiesRepository activityRepository
  }) : this._activityRepository=activityRepository {
    loadActivities();
  }


  loadActivities() async {
    this.activities = await _activityRepository.getActivities();
    notifyListeners();
  }
}