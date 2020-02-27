
import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:flutter/cupertino.dart';

enum ActivityProviderState {
  activitiesLoaded,
  loadingInProgress,
  locationPermissionNotGranted,
  databaseError,
}


class ActivityProvider extends ChangeNotifier {
  IActivityService _activityService;

  ActivityProvider({
    @required IActivityService iActivityService,
  }): this._activityService = iActivityService;
    

     Future<Activity> CreateActivity(Activity newActivity) async {
       try {
          return await _activityService.createActivity(newActivity);
       } catch(_) {
         return null;
       }
       
    
  }
}