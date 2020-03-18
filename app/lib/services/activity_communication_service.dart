import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/models/user.dart';



/// Service used to handle the acivities communication system
///
abstract class IActivityCommunicationService {
  
  /// Retreive the [ActivityCommunication] of the [activity]
  /// 
  /// Returns an [ActivityCommunication] if the operation succeed (never null)
  /// Throw an exception in an error occured
  Future<ActivityCommunication> retreiveActivityCommunication(Activity activity);

  ///
  ///
  ///
  Future acceptParticipant(Activity activity, User user);

  ///
  ///
  ///
  Future rejectParticipant(Activity activity, User user);
  
  /// TODO(dioul) : Add new message
}



/// Implement the [IActivityCommunicationService] to use the Firestore database
/// 
/// 
class FirestoreActivityCommunicationService implements IActivityCommunicationService {

  @override
  Future<ActivityCommunication> retreiveActivityCommunication(Activity activity) {
    // TODO(romain)
    throw UnimplementedError();
  }

  @override
  Future acceptParticipant(Activity activity, User user) async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Future rejectParticipant(Activity activity, User user) async {
    await Future.delayed(Duration(seconds: 3));
  }
}