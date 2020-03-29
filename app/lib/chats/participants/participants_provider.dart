import 'dart:async';

import 'package:app/chats/chat_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/widgets.dart';



/// Represent the current state of the [ParticipantsProvider]
///
/// It concerns particularly the state of the loading of the [ActivityCommunication]
/// instance
enum PaticipantsProviderState {
  /// Nothing happen, the [ActivityCommunication] is not in loading or loded
  idle,

  /// The current [ActivityCommunication] is loaded and available
  loaded,

  /// The current [ActivityCommunication] loading is in progress
  inProgress,

  /// An error occured to load the [ActivityCommunication]
  error,
}



/// Represent the group in which an user is for an activity
enum UserGroup {
  /// the user IS the creator of the activity
  creator,

  /// the suer IS a participant of the activity
  participant,

  /// the user is interested to participate to the activity
  interested,

  /// unknown group
  unknown,
}



/// Handle the communication system related to the [_activity]
///
/// State :
///   - [state] of the current status concerning the loading of the 
///     [userGroup] the group in which the current user is for the [_activity]
///   - [activityCommunication] the communication system related to the [_activity]
///
class ParticipantsProvider extends ChangeNotifier {

  IActivityCommunicationService _communicationService;
  IProfileService _profileService;
  Activity _activity;
  StreamSubscription _streamComm;
  User _user;

  PaticipantsProviderState state = PaticipantsProviderState.idle;
  UserGroup userGroup =  UserGroup.unknown;
  ActivityCommunication activityCommunication;


  ParticipantsProvider({
    @required Activity activity,
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService,
  }) : _activity = activity,
       _communicationService = communicationService,
       _profileService = profileService;


  @override
  dispose() {
    _streamComm?.cancel();
    super.dispose();
  }

  /// Init the listeners (communication system and messages)
  /// 
  /// Listen stream that returned the [ActivityCommunication] related to the
  /// [_activity] and update the state acconrdingly and notify clients
  init() async {
    state = PaticipantsProviderState.inProgress;
    notifyListeners();
    try {
      _user = await _profileService.getUser();
    } catch (_) {}
    _streamComm = _communicationService.retreiveActivityCommunication(_activity)
      .listen((activityCommunication) {
        this.activityCommunication = activityCommunication;
        _updateUserGroup();
        state = PaticipantsProviderState.loaded;
        notifyListeners();
       });
    _streamComm.onError((e) {
      state = PaticipantsProviderState.error;
      notifyListeners();
    });
  }


  /// Add a participant to the participants list
  ///
  /// Returned true is the operaiton succeed, false else
  Future<bool> acceptParticipant(User user) async {
    try {
      await _communicationService.acceptParticipant(_activity, user);
      return true;
    } catch (_) {
      return false;
    }
  }


  /// Reject a participation request 
  /// 
  /// Returned true is the operaiton succeed, false else
  Future<bool> rejectParticipant(User user) async {
    try {
      await _communicationService.rejectParticipant(_activity, user);
      return true;
    } catch (_) {
      return false;
    }
  }


  _updateUserGroup() {
    if (_activity.user == _user)
      userGroup = UserGroup.creator;
    else if (activityCommunication.interestedUsers.contains(_user))
      userGroup = UserGroup.interested;
    else if (activityCommunication.participants.contains(_user))
      userGroup = UserGroup.participant;
    else
      userGroup = UserGroup.unknown;
  }
}
