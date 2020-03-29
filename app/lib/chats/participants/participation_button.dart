import 'package:app/chats/chat_page.dart';
import 'package:app/chats/user_chats/user_chats_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/utils/snackbar_handler.dart';
import 'package:app/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



/// Button used to access to the chat of the activity
/// 
/// It uses the [UserChatsProvider] to know whever if the user is already a 
/// participant of the activity :
///   - if so, the button will redirect the user to the activity chat
///   - if not, the button will ask the provdider to add the user to the
///     interested users list
/// 
/// Of course, to know if the user is already a participant of the activity is
/// an asynchronous operation (as the provider need to communicate with the
/// database). SO, is the provider is not yet completly initialized or if an
/// error occured during this asynchronous operation, an alternative text will
/// be displayed
class ParticipationButton extends StatelessWidget {

  final Activity activity;

  ParticipationButton({
    Key key, 
    @required this.activity
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<UserChatsProvider>(
      builder: (_, chatsProvider, __) {
        switch (chatsProvider.state) {
          case UserChatsState.loaded:
            var isAlreadyInterested = chatsProvider.activities.contains(activity);
            if (isAlreadyInterested)
              return Button(
                child: Text(Strings.activityChat),
                icon: Icon(Icons.chat),
                onPressed: () => openChat(context, activity),
              );
            // else
            return Button(
              child: Text(Strings.iAmInterested),
              onPressed: () => handleParticipation(context),
            );
          
          case UserChatsState.inProgress:
            return Center(child: Text(Strings.loading));

          case UserChatsState.idle:
          case UserChatsState.error:
          default:
            return Center(child: Text(Strings.error));
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
    var chatsProvider = Provider.of<UserChatsProvider>(context, listen: false);
    bool success = await chatsProvider.requestParticipation(activity);
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