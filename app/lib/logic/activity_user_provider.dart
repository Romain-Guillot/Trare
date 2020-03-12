import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter/cupertino.dart';

/// State to represent the provider state
enum ActivityUserProviderState{
  activitiesLoaded,
  loadingInProgress,
  loadingEmptyActivity,
  dataBaseError,
}


class ActivityUserProvider extends ChangeNotifier{

IActivityService _activityService;
IProfileService _iProfileService;

var _state = ActivityUserProviderState.loadingInProgress;

ActivityUserProviderState get state => _state;

set state(value){
  _state = value;
  notifyListeners();
}

List<Activity> activities;

ActivityUserProvider({
  @required IActivityService iActivityService, 
  @required iProfileService,
  }):this._activityService = iActivityService,
  this._iProfileService = iProfileService {
    loadActivities();
  }

/// Load activities created by the [current user] 
  loadActivities()async{

    this._state = ActivityUserProviderState.loadingInProgress;

    var currentUser = await this._getCurrentUser();

    if(currentUser == null){
      this._state = ActivityUserProviderState.dataBaseError;
    } else{
      try{
         this.activities = await this._activityService.retreiveActivitiesUser(user: currentUser);
        if(this.activities == null){
          this._state = ActivityUserProviderState.loadingEmptyActivity;
        } else{
          this._state = ActivityUserProviderState.activitiesLoaded;
        }
      } catch(_){
        this._state =ActivityUserProviderState.dataBaseError;

      }
    }

  }


Future <User> _getCurrentUser() async{
  try{
    var user = await this._iProfileService.getUser();
    return user;
  } catch (e){
    return null;
  }
  
}
  




}