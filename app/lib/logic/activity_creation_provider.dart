
import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:flutter/cupertino.dart';

enum ActivityProviderState {
  activitiesLoaded,
  loadingInProgress,
  emptyActivity,
  databaseError,
}


class ActivityProvider extends ChangeNotifier {
  IActivityService _activityService;

  var _state = ActivityProviderState.loadingInProgress;
   ActivityProviderState get state => _state;
   set state(value) {
     _state = value;
     notifyListeners();
   }

  ActivityProvider({
    @required IActivityService iActivityService,
  }): this._activityService = iActivityService;
    

     Future<Activity> CreateActivity(Activity newActivity) async {
      
          state = ActivityProviderState.loadingInProgress;
          var activity= await _activityService.createActivity(newActivity);
          
          if(activity==null) {
            state = ActivityProviderState.emptyActivity;
            return null;
          }else{
            try {
                  state=ActivityProviderState.activitiesLoaded;             
                  return activity;
            }catch(_) {
              state=ActivityProviderState.databaseError;
              return null;
            }
          }

       
        
       }
       
    
  }
