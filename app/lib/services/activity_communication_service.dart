import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';



/// Service used to handle the acivities communication system
///
abstract class IActivityCommunicationService {
  
  /// Retreive the [ActivityCommunication] of the [activity]
  /// 
  /// Returns an [ActivityCommunication] if the operation succeed (never null)
  /// Throw an exception in an error occured
  Future<ActivityCommunication> retreiveActivityCommunication(Activity activity);

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

}