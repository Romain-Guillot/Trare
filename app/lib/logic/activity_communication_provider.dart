import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/services/activity_communication_service.dart';
import 'package:app/ui/pages/activity_communication_page.dart';
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

  ActivityCommunicationState state = ActivityCommunicationState.idle;
  Activity activity;
  ActivityCommunication activityCommunication;


  ActivityCommunicationProvider({
    @required this.activity,
    @required IActivityCommunicationService communicationService
  }) : this._communicationService = communicationService;


  /// TODO(romain)
  ///
  ///
  load() async {
    activityCommunication = mockActivityCommunication;
  }


  // TODO(dioul) add message method

}
