import 'dart:async';

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

  StreamSubscription _activitiesSubscription;
  User _user;

  UserChatsState _state = UserChatsState.idle;
  UserChatsState get state => _state;
  set state(state) {
    _state = state;
    notifyListeners();
  }
  List<Activity> activities;


  UserChatsProvider({
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService,
    @required IActivityService activityService,
  }) : _communicationService = communicationService,
       _profileService = profileService,
       _activityService = activityService;


  @override
  dispose() {
    _activitiesSubscription?.cancel();
    super.dispose();
  }


   /// Load the [activites], update the [state] and notify clients
  /// 
  /// It listen the stream returned by the [_communicationService.retrieveUserChats]
  /// method and update the state and update the clients each time a new
  /// list of activities is inserted inside the stream
  /// 
  /// Note: the setter of the [state] property automatically notify listeners
   init() async {
     state = UserChatsState.inProgress;
     try {
       _user = await _profileService.getUser();
     } catch (_) {
       state = UserChatsState.error;
     }
    _activitiesSubscription = _communicationService.retrieveUserChats(_user)
      .listen((newActivities) {
        activities = newActivities;
        state = UserChatsState.loaded;
      });
    _activitiesSubscription.onError((e) {
      state = UserChatsState.error;
    });
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