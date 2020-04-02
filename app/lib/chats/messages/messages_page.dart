import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/widgets/error_widgets.dart';
import 'package:app/shared/widgets/loading_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';



/// Page to display the messages, or if not avaible a loding / error widget
///
///
class MessagesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var messagesProvider = Provider.of<MessagesProvider>(context, listen: false);
    return StreamBuilder<List<Message>>(
      stream: messagesProvider.messages,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return ErrorWidgetWithReload(
            message: "Cannot load messages",
            onReload: () {},
          );
        if (!snapshot.hasData)
          return LoadingWidget();

        return Column(
          children: <Widget>[
            Expanded(
              child: MessagesList(
                activity: messagesProvider.activity,
                messages: snapshot.data
              ),
            ),
            SendMessageTextField(
              onSent: (messageContent) async {
                return await onSend(context, messageContent);
              } 
            )
          ],
        );
      }
    );
  }

  Future<bool> onSend(BuildContext context, String content) async{
    var messagesProvider = Provider.of<MessagesProvider>(context, listen: false);
    if (content.isNotEmpty) {
      var newMessage = Message.create(
        content: content, 
        publicationDate: DateTime.now(),
        user: messagesProvider.user,
      );
      var res = await messagesProvider.addMessage(newMessage);
      return res != null;
    }
    return false;
  }
}


/// Display the list of messages
///
///
class MessagesList extends StatelessWidget {

  final Activity activity;
  final List<Message> messages;

  MessagesList({
    Key key,
    @required this.activity,
    @required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: messages.length,
      itemBuilder: (_, index) {
        var message = messages[index];
        var owner = message.user.uid == activity.user.uid;
        return MessageItem(
          message: message,
          owner: owner,
        );
      }
    );
  }
}


/// Display a message in a bubble
/// 
/// 
class MessageItem extends StatelessWidget {

  final Message message;
  final bool owner;

  MessageItem({
    Key key,
    @required this.message,
    @required this.owner
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Bubble(
      style: BubbleStyle(
        nip: owner ? BubbleNip.rightTop : BubbleNip.leftTop,
        elevation: 0,
        color: owner ? colorScheme.primary.withOpacity(0.2) : colorScheme.surface,
        radius: Radius.circular(Dimens.radius),
        alignment: owner ? Alignment.topRight : Alignment.topLeft,
        margin: BubbleEdges.only(bottom: Dimens.smallSpacing)
      ),
      child: Text(message.content),
    );
  }
}



/// TextField used to write message with a button to send it
/// call [onSent] method when the user click on the send button
/// 
class SendMessageTextField extends StatefulWidget {

  final Future<bool> Function(String) onSent;

  SendMessageTextField({
    Key key,
    @required this.onSent,
  }) : super(key: key);

  @override
  _SendMessageTextFieldState createState() => _SendMessageTextFieldState();
}

class _SendMessageTextFieldState extends State<SendMessageTextField> {

  final TextEditingController messageController = TextEditingController();
  bool emptyMessage = true;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: InputDecoration(
              hintText:  Strings.messageTextfield,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
              border: InputBorder.none,
            ),
            onChanged: (newValue) {
              setState(() => emptyMessage = messageController.text.isEmpty);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            color: !emptyMessage ? colorScheme.primary : Colors.grey,
            onPressed: () async {
              var isSent = await widget.onSent(messageController.text);
              if (isSent)
                messageController.clear();
            },
            icon: Icon(Icons.send),
          ),
        )
      ],
    );
  }
}