import 'dart:async';

import 'package:app/chats/chat_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/widgets.dart';



/// Represent the current state of the [ActivityCommunicationProvider]
///
/// It concerns particularly the state of the loading of the [ActivityCommunication]
/// instance
enum ActivityCommunicationState {
  /// Nothing happen, the [ActivityCommunication] is not in loading or loded
  idle,

  /// The current [ActivityCommunication] is loaded and available
  loaded,

  /// The current [ActivityCommunication] loading is in progress
  inProgress,

  /// An error occured to load the [ActivityCommunication]
  error,
}

enum UserGroup {

  creator,

  participant,

  interested,

  unknown,
}



/// Handle the communication system related to the [activity]
///
/// State :
///   - [state] of the current status concerning the loading of the 
///     [activityCommunication]
///   - [activity] the current activity
///   - [activityCommunication] the communication system related to the [activity]
///
class ActivityCommunicationProvider extends ChangeNotifier {

  IActivityCommunicationService _communicationService;
  IProfileService _profileService;
  StreamSubscription _streamComm;
  User _user;

  ActivityCommunicationState state = ActivityCommunicationState.idle;
  UserGroup userGroup =  UserGroup.unknown;
  Activity activity;
  ActivityCommunication activityCommunication;


  ActivityCommunicationProvider({
    @required this.activity,
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService,
  }) : _communicationService = communicationService,
       _profileService = profileService;


  @override
  dispose() {
    _streamComm?.cancel();
    super.dispose();
  }

  /// Init the listeners (communication system and messages)
  init() async {
    state = ActivityCommunicationState.inProgress;
    notifyListeners();
    try {
      _user = await _profileService.getUser();
    } catch (_) {}
    _streamComm = _communicationService.retreiveActivityCommunication(activity)
      .listen((activityCommunication) {
        this.activityCommunication = activityCommunication;
        _updateUserGroup();
        state = ActivityCommunicationState.loaded;
        notifyListeners();
       });
    _streamComm.onError((e) {
      state = ActivityCommunicationState.error;
      notifyListeners();
    });
  }

  _updateUserGroup() {
    if (activity.user == _user)
      userGroup = UserGroup.creator;
    else if (activityCommunication.interestedUsers.contains(_user))
      userGroup = UserGroup.interested;
    else if (activityCommunication.participants.contains(_user))
      userGroup = UserGroup.participant;
    else
      userGroup = UserGroup.unknown;
  }


  Future<bool> acceptParticipant(User user) async {
    try {
      await _communicationService.acceptParticipant(activity, user);
      return true;
    } catch (_) {
      return false;
    }
  }


  Future<bool> rejectParticipant(User user) async {
    try {
      await _communicationService.rejectParticipant(activity, user);
      return true;
    } catch (_) {
      return false;
    }
  }
}
