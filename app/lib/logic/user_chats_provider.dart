import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_communication_service.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter/widgets.dart';


enum UserChatsState {
  idle,
  inProgress,
  loaded,
  error,
}


class UserChatsProvider extends ChangeNotifier {

  final IActivityCommunicationService _communicationService;
  final IActivityService _activityService;
  final IProfileService _profileService;
  User _user;

  List<Activity> activities;
  UserChatsState state = UserChatsState.idle;

  UserChatsProvider({
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService,
    @required IActivityService activityService,
  }) : _communicationService = communicationService,
       _profileService = profileService,
       _activityService = activityService;


  init() async {
    state = UserChatsState.inProgress;
    notifyListeners();
    try {
      _user = await _profileService.getUser();
      activities = await _communicationService.findUserChats(_user);
      activities.addAll(
        await _activityService.retreiveActivitiesUser(user: _user)
      );
      state = UserChatsState.loaded;
    } catch (_) {
      state = UserChatsState.error;
    }
    notifyListeners();
  }


  onInterested(Activity activity) async {
    try {
      if (_user == null)
        _user = await _profileService.getUser();
      _communicationService.registerInterestedUser(_user, activity);
      await init();
      return true;
    } catch (_) {
      return false;
    }
  }
}