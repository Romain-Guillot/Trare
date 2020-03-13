// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: Done
import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter/cupertino.dart';

/// State to represent the provider state
enum ActivityUserProviderState {
  idle,
  loaded,
  loading,
  error,
}


///
/// The [activities] is null if the activities are not yet loaded or if an error
/// occured
class ActivityUserProvider extends ChangeNotifier {

  IActivityService _activityService;
  IProfileService _profileService;

  var state = ActivityUserProviderState.idle;
  List<Activity> activities;

  ActivityUserProvider({
    @required IActivityService activityService,
    @required IProfileService profileService,
  }) : this._activityService = activityService,
       this._profileService = profileService;


  /// Load activities created by the [current user]
  loadActivities() async {
    state = ActivityUserProviderState.loading;

    var currentUser = await _getCurrentUser();

    if (currentUser == null) {
      state = ActivityUserProviderState.error;
      activities = null;
    } else {
      try {
        activities = await _activityService.retreiveActivitiesUser(user: currentUser);
        state = ActivityUserProviderState.loaded;
      } catch (_) {
        state = ActivityUserProviderState.error;
        activities = null;
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
