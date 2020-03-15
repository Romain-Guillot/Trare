
import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter/cupertino.dart';


/// the [ActivityProvider] takes the activity created by the [user] and after he
/// gives this activity to the [IActivityService]
class ActivityCreationProvider extends ChangeNotifier {
  
  IActivityService _activityService;
  IProfileService _profileService;

  ActivityCreationProvider({
    @required IActivityService activityService,
    @required IProfileService profileService
  }): this._activityService = activityService,
      this._profileService = profileService;
    
  /// this function gives the new activity to the service class that have to map the activity in
  /// noSQL data  before to insert it  in the firestore
  /// 
  /// Returns the created activity if succeed
  /// Returns null if an occured occured
  Future<Activity> createActivity(Activity newActivity) async {
    try {
      var profile = await _profileService.getUser();
      newActivity.user = profile;
      var activity = await _activityService.createActivity(newActivity);
      return activity;
    } catch (_) {
      return null;
    }
  }
}
