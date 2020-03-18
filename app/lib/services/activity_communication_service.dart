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

  /// Add a [Message] of the [activity] in database
  /// 
  /// Returns the created [ActivityCommunication] if insertion is succeed
  /// null is never return
  /// An exception can be throwed if an error occured
  Future<Message> addMessage(Activity activity, Message message);
}



/// Implement the [IActivityCommunicationService] to use the Firestore database
/// 
/// 
class FirestoreActivityCommunicationService implements IActivityCommunicationService {
  
  final _firestore = Firestore.instance;
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
        var message = _FirestoreMessageAdapter(data: doc.data, user: user);
        messages.add(message);
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


  @override
  Future<Message> addMessage(Activity activity, Message message) async {
    var messageData = _FirestoreMessageAdapter.toMapMessageIntoNoSQL(message);

    if (messageData != null) {
      var messageCol = _firestore.collection(FBQualifiers.ACT_COL)
                                 .document(activity.id)
                                 .collection(FBQualifiers.MSG_COL);
      await messageCol.add(messageData);
      return _FirestoreMessageAdapter(data: messageData, user: message.user);
    }
    return Future.error(null);
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

/// Adpater used to adapt noSQL data ([Map]) to [Message]
///
/// So it implements [Message], and take a [Map] as constructor paramater
/// to build out [Message] from the noSQL data. It allows to hide the complexity
/// of transformation.
/// 
/// See https://refactoring.guru/design-patterns/adapter to know more about the
/// adapter pattern.
class _FirestoreMessageAdapter extends Message {

  @override DateTime publicationDate;
  @override String content;
  @override User user;

  _FirestoreMessageAdapter({@required Map<String, dynamic> data, User user }) {
    this.publicationDate = dateFromTimestamp(data[FBQualifiers.MSG_DATE]);
    this.content = data[FBQualifiers.MSG_CONTENT];
    this.user = user;
  }

  DateTime dateFromTimestamp(dynamic data) {
    try{
      return (data as Timestamp).toDate();
    }catch(_){
      return null;
    }
  }

  /// Method used to adapt ([Mesage]) to noSQL data [Map]
  static Map<String, Object> toMapMessageIntoNoSQL(Message message) => {
    FBQualifiers.MSG_DATE: Timestamp.fromDate(DateTime.now()),
    FBQualifiers.MSG_CONTENT: message.content,
    FBQualifiers.MSG_DATE: message.user,
    FBQualifiers.MSG_ACTIVITY_ID: message.id
  };
}


