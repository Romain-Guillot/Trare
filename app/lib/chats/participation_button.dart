import 'package:app/chats/chat_page.dart';
import 'package:app/chats/user_chats_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/utils/snackbar_handler.dart';
import 'package:app/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Button to initiate the communication system
///
/// It will initiate the communication system between the current user (the 
/// user who click on this button) and the creator of the activity.
class ParticipationButton extends StatelessWidget {

  final Activity activity;

  ParticipationButton({Key key, @required this.activity}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<UserChatsProvider>(
      builder: (_, chatsProvider, __) {
        switch (chatsProvider.state) {
          case UserChatsState.loaded:
            var isAlreadyInterested = chatsProvider.activities.contains(activity);
            if (isAlreadyInterested)
              return Button(
                child: Text("Chat"),
                icon: Icon(Icons.chat),
                onPressed: () => openChat(context, activity),
              );
            // else
            return Button(
              child: Text(Strings.iAmInterested),
              onPressed: () => handleParticipation(context),
            );
          
          case UserChatsState.inProgress:
            return Text(Strings.loading);

          case UserChatsState.idle:
          case UserChatsState.error:
          default:
            return Text("Error");
        }

      } 
    );
  }

  openChat(context, activity) {
    Navigator.push(context, MaterialPageRoute (
      builder: (context) => ActivityCommunicationPage(activity: activity),
    ));
  }

  handleParticipation(context) async {
    var chatProvider = Provider.of<UserChatsProvider>(context, listen: false);
    bool success = await chatProvider.onInterested(activity);
    if (success)
      openChat(context, activity);
    else
      showSnackbar(
        context: context, 
        content: Text(Strings.unexpectedError), 
        critical: true
      );
  }
}