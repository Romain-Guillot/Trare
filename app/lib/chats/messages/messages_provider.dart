import 'dart:async';

import 'package:app/chats/chat_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/widgets.dart';


/// Provider used to handle the messages of an the chat of the [activity]
/// 
/// The messages can be listen through the [messages] stream.
/// A message can be add thanks to the [addMessage] method.
/// 
/// When creating, the Provider has to call the [init] method to initialized
/// the stream of messages and the connected [user] so it is not necessary to
/// call this method anywhere.
/// 
/// Note that the [messages] is a [Stream] of [List<Message], evrything there
/// will be new messages added in the database, the stream will be updated
/// automatically. 
/// No need to call [notifyListener] as the messages can be read directly from
/// the stream in real-time.
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
      

  /// Retrieve the stream of messages from the communication service
  /// 
  /// Retrieve also the connected user, it can be used in particular to know
  /// if a message is sent by the current user (to adapt the UI for example)
  init() async {
    messages = _communicationService.retrieveMessages(activity);
    try{
      user = await _profileService.getUser();   
    } catch (_) { }
  }


  /// Add a new message in the [activity] chat
  /// 
  /// Returns the created [message] if succeed
  /// Returns null if an occured occured
  Future<Message> addMessage( Message message) async {
    try{
      Message result = await _communicationService.addMessage(activity, message);
      return result;
    } catch(_) {
      return null;
    }
  }
}