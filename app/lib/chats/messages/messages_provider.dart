import 'dart:async';

import 'package:app/chats/chat_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/widgets.dart';



/// Represent the current state of the [MessagesProvider]
///
/// It concerns particularly the state of the loading of the [ActivityCommunication]
/// instance
enum MessagesProviderState {
  /// Nothing happen, the [ActivityCommunication] is not in loading or loded
  idle,

  /// The current [ActivityChat] is loaded and available
  loaded,

  /// the messages of the current [ActivityChat] is loaded and available
  loadedMessages,

  /// The current [ActivityChat] loading is in progress
  inProgress,

  /// An error occured to load the [ActivityChat]
  error,

}



/// Contains two methods :
/// 1 pour load les messages (déjà faite)
/// 1 pour ajouter un message (à faire)
///
///
class MessagesProvider extends ChangeNotifier {

  IActivityCommunicationService _communicationService;
  StreamSubscription _streamMessages;
  IProfileService _profileService;
  User _user;

  User get user => _user;

  
  MessagesProviderState state = MessagesProviderState.inProgress;
  Stream<List<Message>> messages;
  List<Message> listMessages;
  Activity activity;
  //ActivityCommunication activityCommunication;
  
  

  MessagesProvider({
    @required this.activity,
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService
  }) :_communicationService = communicationService,
      _profileService = profileService;
      

  @override
  dispose() {
    _streamMessages?.cancel();
    super.dispose();
  }

  /// Init the listeners (communication system and messages)
  init() async {
    state = MessagesProviderState.inProgress;
    notifyListeners();
    try{
      _user = await _profileService.getUser();
    } catch (_) {}
    
     _streamMessages = _communicationService.retrieveMessages(activity)
                .listen((listMessage) { 
                    this.listMessages = listMessage;
                    notifyListeners();
                });
    
    if(_streamMessages != null){
      messages = _communicationService.retrieveMessages(activity);
      state = MessagesProviderState.loadedMessages;
      notifyListeners();
    }
    /*_streamMessages.onError((e) {
      state = MessagesProviderState.error;
    });*/
    
  }

 /// this function gives the new [message] to the service class that have to map the it in
  /// noSQL data  before to insert it  in the database
  /// 
  /// Returns the created [message] if succeed
  /// Returns null if an occured occured
  Future<Message> addMessage( Message newMessage) async {
    try{
      init();
      var message = await _communicationService.addMessage(activity, newMessage);
      return message;
    } catch(_) {
      state = MessagesProviderState.error;
      return null;
    }
  }
}