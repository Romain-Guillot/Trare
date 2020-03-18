import 'dart:async';

import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



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

  var _firestore = Firestore.instance;

  @override
  Future<ActivityCommunication> retreiveActivityCommunication(Activity activity) {
    // TODO(romain)
    throw UnimplementedError();
  }

  @override
  Future acceptParticipant(Activity activity, User user) async {
    var doc = _firestore.collection("actvities").document(activity.id);
    await doc.updateData({
      "participants": FieldValue.arrayUnion([user.uid]),
      "interested_users": FieldValue.arrayRemove([user.uid])
    });
  }

  @override
  Future rejectParticipant(Activity activity, User user) async {
    var doc = _firestore.collection("actvities").document(activity.id);
    await doc.updateData({
      "interested_users": FieldValue.arrayRemove([user.uid])
    });
  }
}