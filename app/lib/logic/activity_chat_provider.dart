import 'dart:async';

import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/services/activity_communication_service.dart';
import 'package:flutter/widgets.dart';



/// Gère le chat d'une activité
/// 
/// State :
/// l'activité courrante
/// les messages du chats (mient à jour en temps réel)
enum ActivityChatState {

  /// The current [ActivityChat] is loaded and available
  loaded,

  /// the messages of the current [ActivityChat] is loaded and available
  loadedMessages,

  /// The current [ActivityChat] loading is in progress
  inProgress,

  /// An error occured to load the [ActivityChat]
  error,

}
/// Contient 2 methodes :
/// 1 pour load les messages (déjà faite)
/// 1 pour ajouter un message (à faire)
///
///
class ActivityChatProvider extends ChangeNotifier {

  IActivityCommunicationService _communicationService;
  StreamSubscription _streamMessages;
  ActivityChatState state = ActivityChatState.inProgress;

  Activity activity;
  Stream<List<Message>> messages;


  ActivityChatProvider({
    @required this.activity,
    @required IActivityCommunicationService communicationService
  }) : this._communicationService = communicationService;


  @override
  dispose() {
    _streamMessages?.cancel();
    super.dispose();
  }


  init() {
    messages = _communicationService.retrieveMessages(activity);
    if(messages != null){
      state = ActivityChatState.loadedMessages;
    }
  }

 /// this function gives the new [message] to the service class that have to map the it in
  /// noSQL data  before to insert it  in the database
  /// 
  /// Returns the created [message] if succeed
  /// Returns null if an occured occured
  Future<Message> addMessage( Message newMessage) async {
    try{
      var message = await _communicationService.addMessage(activity, newMessage);
      init();
      return message;
    } catch(_) {
      state = ActivityChatState.error;
      return null;
    }
  }


  // add message

}