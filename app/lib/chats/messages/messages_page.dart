import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/widgets/buttons.dart';
import 'package:app/shared/widgets/error_widgets.dart';
import 'package:app/shared/widgets/loading_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';



/// Widget that displays the list of messages of an activity chat and let the
/// user add new messages.
/// 
/// The list messages are retrieve thanks to the [MessagesProvider]. This 
/// provider has been previously initialized with the correct activity, so no
/// need to any configuration of the provider here, just get back the messages
/// or ask the provider to add a new message.
/// 
/// As it is specified in the documentation of the [MessagesProvider], we 
/// dinstinguish 3 cases :
///   - the messages are correctly loaded : no error in the stream and the 
///     stream contains data
///   - the messages cannot be loaded : an error are push in the stream
///   - the messages are still in loading : no data and no error pushed in the 
///     stream
/// 
/// The messages are available through a stream, so the [StreamBuilder] widget
/// is used to retrieve and display a widget based on the stream state :
///   - if error : [ErrorWidgetWithReload]
///   - if loading in progress : [LoadingWidget]
///   - if messages loaded : [MessagesList] and [SendMessageTextField]
class MessagesPage extends StatelessWidget {

  MessagesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messagesProvider = Provider.of<MessagesProvider>(context, listen: false);
    return StreamBuilder<List<Message>>(
      stream: messagesProvider.messages,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return ErrorWidgetWithReload(
            message: Strings.messagesLoadingError,
            onReload: () => messagesProvider.init(),
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
              onSent: (message) async => await _onSend(context, message)
            )
          ],
        );
      }
    );
  }

  /// Function used to ask the provider to send a new message in the activity
  /// chat. This message contain the message [content].
  Future<bool> _onSend(BuildContext context, String content) async{
    var messagesProvider = Provider.of<MessagesProvider>(context, listen: false);
    Message createdMessage;
    if (content.isNotEmpty) {
      var newMessage = Message.create(
        content: content, 
        publicationDate: DateTime.now(),
        user: messagesProvider.user,
      );
      createdMessage = await messagesProvider.addMessage(newMessage);
    }
    return createdMessage != null;
  }
}



/// Display the list of [messages] of the [activity]
///
/// Simply build a list view (through the builder constructor to have an
/// optimized list view with recycled items), the list view is composed of
/// [MessageItem] that display the message bubble.
class MessagesList extends StatefulWidget {

  final Activity activity;
  final Iterable<Message> messages;

  MessagesList({
    Key key,
    @required this.activity,
    @required this.messages,
  }) : super(key: key);

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {

  final ScrollController scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
      reverse: true,
      itemCount: widget.messages.length,
      itemBuilder: (_, index) {
        var message = widget.messages.elementAt(index);
        var owner = message.user.uid == widget.activity.user.uid;
        return MessageItem(
          message: message,
          owner: owner,
        );
      }
    );
  }
}



/// Display a [message] in a bubble with a specific style based on if the author
/// of the message if the current connect user ([owner] property). 
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
/// 
/// The [onSent] method is called when the user click on the "send" button. This
/// method has to return true is the operation succeed, false else. So if the 
/// operation succeed, the text field is clear, if not nothing happened and the 
/// user can retry to send the message.
/// Of course it is an asynchronous operation, so during the operation process,
/// the "send" button is disable to prevent same message sent multiple times.
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
  bool sendingInProgress = false;

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
          margin: EdgeInsets.only(
            left: Dimens.screenPaddingValue,
            right: Dimens.smallSpacing // just to add little spacing between the screen and the button
          ),
          child: Button(
            color: (!emptyMessage || sendingInProgress)
                      ? colorScheme.primary 
                      : Colors.grey,
            onPressed: sendingInProgress ? null : () async {
              setState(() => sendingInProgress = true);
              var isSent = await widget.onSent(messageController.text);
              if (isSent)
                messageController.clear();
              setState(() => sendingInProgress = false);
            },
            child: Icon(Icons.send),
          ),
        )
      ],
    );
  }
}