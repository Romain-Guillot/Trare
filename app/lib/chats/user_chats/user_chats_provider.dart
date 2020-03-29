import 'package:app/activities/activity_service.dart';
import 'package:app/chats/chat_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/widgets.dart';



/// Represent the [UserChatsProvider] state, in particular the status related
/// to the [UserChatsProvider.activities] state (loading, loaded, etc.)
enum UserChatsState {
  /// nothing happened
  idle,

  /// The activities that the user is interested, paricipant or the creator are 
  /// in progress
  inProgress,

  /// The activities that the user is interested, paricipant or the creator are 
  /// loaded
  loaded,

  /// An error occured while retrieving the activities that the user is 
  /// interested, paricipant or the creator
  error,
}



/// Provider that handle the activities in which the user is interested, 
/// participant or creator
///
/// It contains the following state :
///   - [state]
///   - [activities]
/// 
/// Moreover, the method [requestParticipation] can be used to request a
/// participation to an activity.
/// 
/// By default, the [state] is [UserChatsState.idle], consider calling the
/// [init] method to load the [activities].
class UserChatsProvider extends ChangeNotifier {

  final IActivityCommunicationService _communicationService;
  final IActivityService _activityService;
  final IProfileService _profileService;

  User _user;

  UserChatsState state = UserChatsState.idle;
  List<Activity> activities;


  UserChatsProvider({
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService,
    @required IActivityService activityService,
  }) : _communicationService = communicationService,
       _profileService = profileService,
       _activityService = activityService;


  /// Load the [activites], update the [state] and notify clients
  init() async {
    state = UserChatsState.inProgress;
    notifyListeners();
    try {
      _user = await _profileService.getUser();
      activities = await _communicationService.retrieveUserChats(_user);
      activities.addAll(
        await _activityService.retreiveActivitiesUser(user: _user)
      );
      state = UserChatsState.loaded;
    } catch (_) {
      state = UserChatsState.error;
    }
    notifyListeners();
  }


  /// Request a participation to the [activity] for the current connected user
  ///
  /// Return true if the operation succeed, false if not
  Future<bool> requestParticipation(Activity activity) async {
    try {
      if (_user == null)
        _user = await _profileService.getUser();
      _communicationService.requestParticipation(_user, activity);
      await init();
      return true;
    } catch (_) {
      return false;
    }
  }
}