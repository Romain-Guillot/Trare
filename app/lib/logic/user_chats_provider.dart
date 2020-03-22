import 'package:app/models/activity.dart';
import 'package:app/services/activity_communication_service.dart';
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
  final IProfileService _profileService;

  List<Activity> activities;
  UserChatsState state = UserChatsState.idle;

  UserChatsProvider({
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService,
  }) : _communicationService = communicationService,
       _profileService = profileService;


  init() async {
    state = UserChatsState.inProgress;
    notifyListeners();
    try {
      var user = await _profileService.getUser();
      activities = await _communicationService.findUserChats(user);
      state = UserChatsState.loaded;
    } catch (_) {
      state = UserChatsState.error;
    }
    notifyListeners();
  }
}