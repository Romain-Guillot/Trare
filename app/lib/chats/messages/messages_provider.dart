import 'dart:async';

import 'package:app/chats/chat_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/widgets.dart';


/// Contains two methods :
/// 1 pour load les messages (déjà faite)
/// 1 pour ajouter un message (à faire)
///
///
class MessagesProvider extends ChangeNotifier {

  final IActivityCommunicationService _communicationService;
  final IProfileService _profileService;

  User user;
  Stream<List<Message>> messages;
  Activity activity;
  

  MessagesProvider({
    @required this.activity,
    @required IActivityCommunicationService communicationService,
    @required IProfileService profileService
  }) :_communicationService = communicationService,
      _profileService = profileService;
      

  /// Init the listeners (communication system and messages)
  init() async {
    messages = _communicationService.retrieveMessages(activity);
    try{
      user = await _profileService.getUser();   
    } catch (_) {}
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
      return null;
    }
  }
}