import 'dart:async';

import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/models/user.dart';
import 'package:app/services/firebase_identifiers.dart';
import 'package:app/services/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';



/// Service used to handle the acivities communication system
///
abstract class IActivityCommunicationService {
  
  /// Retreive the [ActivityCommunication] of the [activity]
  /// 
  /// Returns an [ActivityCommunication] if the operation succeed (never null)
  /// Throw an exception in an error occured
  Stream<ActivityCommunication> retreiveActivityCommunication(Activity activity);

  /// Returns a stream that contains the list of [Message] of the [activity]
  ///
  /// Note: the stream is automatically update with new messages
  Stream<List<Message>> retrieveMessages(Activity activity);

  /// Update the database to accept a new user as participant
  ///
  /// Nothing returned if the operation succeed
  /// An exception is throwed if an error occured
  Future acceptParticipant(Activity activity, User user);

  /// Update the database to reject a user request to be part of the particpants
  ///
  /// Nothing returned if the operation succeed
  /// An exception is throwed if an error occured
  Future rejectParticipant(Activity activity, User user);
}



/// Implement the [IActivityCommunicationService] to use the Firestore database
/// 
/// 
class FirestoreActivityCommunicationService implements IActivityCommunicationService {

  var _firestore = Firestore.instance;
  IProfileService _profileService;


  FirestoreActivityCommunicationService({
    @required IProfileService profileService
  }) : this._profileService = profileService;


  @override
  Stream<ActivityCommunication> retreiveActivityCommunication(Activity activity) {
    var streamController = StreamController<ActivityCommunication>();
    var activityDoc = _firestore.collection(FBQualifiers.ACT_COL)
                                .document(activity.id);

    activityDoc.snapshots().listen((docSnap) async {      
      var interestedUsersIds = docSnap.data[FBQualifiers.ACT_INTERESTED] as List;
      var interestedUsers = await _idsToUsers(interestedUsersIds.cast<String>());
      
      var participantsIds = docSnap.data[FBQualifiers.ACT_PARTICIPANTS] as List;
      var participants = await _idsToUsers(participantsIds.cast<String>());
      
      var comm = ActivityCommunication(
        activity: activity,
        interestedUsers: interestedUsers,
        participants: participants
      );
      streamController.add(comm);
    });

    return streamController.stream;
  }


  Stream<List<Message>> retrieveMessages(Activity activity) {
    var messagesStreamController = StreamController<List<Message>>();
    var activityDoc = _firestore.collection(FBQualifiers.ACT_COL)
                                .document(activity.id)
                                .collection(FBQualifiers.MSG_COL);
    
    activityDoc.snapshots().listen((querySnap) async {
      var messages = <Message>[];
      for (var doc in querySnap.documents) {
        var user = await _profileService.getUser(userUID: doc["user"]);
        messages.add(null); // TODO with Message adapter
      }
      messagesStreamController.add(messages);
    });
    return messagesStreamController.stream;
  }


  @override
  Future acceptParticipant(Activity activity, User user) async {
    var doc = _firestore.collection(FBQualifiers.ACT_COL)
                        .document(activity.id);
    await doc.updateData({
      FBQualifiers.ACT_PARTICIPANTS: FieldValue.arrayUnion([user.uid]),
      FBQualifiers.ACT_INTERESTED: FieldValue.arrayRemove([user.uid])
    });
  }


  @override
  Future rejectParticipant(Activity activity, User user) async {
    var doc = _firestore.collection(FBQualifiers.ACT_COL)
                        .document(activity.id);
    await doc.updateData({
      FBQualifiers.ACT_INTERESTED: FieldValue.arrayRemove([user.uid])
    });
  }


  Future<List<User>> _idsToUsers(List<String> ids) async {
    var res = <User>[];
    for (var id in ids) {
      try {
        var user = await _profileService.getUser(userUID: id);
        res.add(user);
      } catch (_) { }
    }
    return res;
  }
}