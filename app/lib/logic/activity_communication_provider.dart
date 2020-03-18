import 'dart:async';

import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_communication_service.dart';
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



///
///
///
class ActivityCommunicationProvider extends ChangeNotifier {

  IActivityCommunicationService _communicationService;

  StreamSubscription _streamComm;
  StreamSubscription _streamMessages;

  ActivityCommunicationState state = ActivityCommunicationState.idle;
  Activity activity;
  ActivityCommunication activityCommunication;
  Stream<List<Message>> messages;


  ActivityCommunicationProvider({
    @required this.activity,
    @required IActivityCommunicationService communicationService
  }) : this._communicationService = communicationService;


  @override
  dispose() {
    _streamComm?.cancel();
    _streamMessages?.cancel();
    super.dispose();
  }

  /// TODO(romain)
  ///
  ///
  load() async {
    state = ActivityCommunicationState.inProgress;
    notifyListeners();

    _communicationService.retreiveActivityCommunication(activity)
      .listen((activityCommunication) {
        this.activityCommunication = activityCommunication;
        state = ActivityCommunicationState.loaded;
        notifyListeners();
       })
      .onError((e) {
        state = ActivityCommunicationState.error;
      });
    
    this.messages = _communicationService.retrieveMessages(activity);
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


  // TODO(dioul) add message method

}
