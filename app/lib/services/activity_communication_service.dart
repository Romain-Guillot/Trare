import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';



/// Service used to handle the acivities communication system
///
abstract class IActivityCommunicationService {
  
  /// Retreive the [ActivityCommunication] of the [activity]
  /// 
  /// Returns an [ActivityCommunication] if the operation succeed (never null)
  /// Throw an exception if an error occured
  Future<ActivityCommunication> retreiveActivityCommunication(Activity activity);

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

  @override
  Future<ActivityCommunication> retreiveActivityCommunication(Activity activity) {
    // TODO(romain)
    throw UnimplementedError();
  }

  @override
  Future<Message> addMessage(Activity activity, Message message) async {
    var messageData = _FirestoreMessageAdapter.toMapMessageIntoNoSQL(message);

    if(messageData != null){
      var messageCol = _firestore.collection(_Identifiers.ACTIVITY_COL)
      .document(activity.id)
      .collection(_Identifiers.MESSAGES_COL);
      await messageCol.add(messageData);
      return _FirestoreMessageAdapter(data: messageData, user: message.user);
    }
    return Future.error(null);
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

    this.publicationDate = dateFromTimestamp(data[_Identifiers.MESSAGE_PUBLICATION_DATE]);
    this.content = data[_Identifiers.MESSAGE_CONTENT];
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

    _Identifiers.MESSAGE_PUBLICATION_DATE: Timestamp.fromDate(DateTime.now()),
    _Identifiers.MESSAGE_CONTENT: message.content,
    _Identifiers.MESSAGE_USER: message.user,
    _Identifiers.ACTIVITY_ID: message.id

  };
}

/// Identifiers (name of collection/fiels) used in the Cloud Firestore
/// NoSQL database to store messages
/// See the corresponding specifications `documents > archi_server.md` (french)
class _Identifiers {

  static const ACTIVITY_COL = "activities";
  static const MESSAGES_COL = "messages";

  static const ACTIVITY_ID = "id_activity";
  static const MESSAGE_CONTENT = "content";
  static const MESSAGE_PUBLICATION_DATE = "publication_date";
  static const MESSAGE_USER = "user";


}