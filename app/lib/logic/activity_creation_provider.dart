
import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:flutter/cupertino.dart';


/// the [ActivityProvider] takes the activity created by the [user] and after he
/// gives this activity to the [IActivityService]
class ActivityCreationProvider extends ChangeNotifier {
  IActivityService _activityService;


  ActivityCreationProvider({
    @required IActivityService iActivityService,
  }): this._activityService = iActivityService;
    
    /// this function gives the new activity to the service class that have to map the activity in
    /// noSQL data  before to insert it  in the firestore
     Future<Activity> createActivity(Activity newActivity) async {
          var activity= await _activityService.createActivity(newActivity);
          return activity;
       }
       
    
  }
