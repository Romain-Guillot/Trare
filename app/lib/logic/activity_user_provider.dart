import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter/cupertino.dart';

/// State to represent the provider state
enum ActivityUserProviderState {
  activitiesLoaded,
  loadingInProgress,
  dataBaseError,
}


class ActivityUserProvider extends ChangeNotifier {

  IActivityService _activityService;
  IProfileService _profileService;

  var state = ActivityUserProviderState.loadingInProgress;
  List<Activity> activities;

  ActivityUserProvider({
    @required IActivityService activityService,
    @required IProfileService profileService,
  }) : this._activityService = activityService,
      this._profileService = profileService;


  /// Load activities created by the [current user]
  loadActivities() async {
    state = ActivityUserProviderState.loadingInProgress;

    var currentUser = await _getCurrentUser();

    if (currentUser == null) {
      state = ActivityUserProviderState.dataBaseError;
    } else {
      try {
        activities = await _activityService.retreiveActivitiesUser(user: currentUser);
        state = ActivityUserProviderState.activitiesLoaded;
      } catch (_) {
        state = ActivityUserProviderState.dataBaseError;
      }
    }
    notifyListeners();
  }
  

  Future<User> _getCurrentUser() async {
    try {
      var user = await _profileService.getUser();
      return user;
    } catch (e) {
      return null;
    }
  }
}
