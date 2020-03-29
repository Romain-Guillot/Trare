
import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';


class MessagesPage extends StatelessWidget {
  final ActivityCommunication activityCommunication;
  Activity get activity => activityCommunication.activity;
  MessagesPage({
    Key key,
    @required this.activityCommunication
  }): super(key: key);
  
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  

 
  @override
  Widget build(BuildContext context) {
     var provider = Provider.of<MessagesProvider>(context, listen: false);
     var messages = provider.messages;
     
     void sendMessage(String content) {

    if(content.trim() != '') {
        var newMessage = new Message(
          content: content, 
          publicationDate: DateTime.now(),
          id: provider.activity.id,
          user: provider.user,
        );
        provider.addMessage(newMessage);
        textEditingController.clear();
    } else {
       Fluttertoast.showToast(msg: 'Nothing to send');
    }

  }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder<List<Message>>(
              stream: messages,
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => (snapshot.data[index].user.uid == activity.user.uid) ?
                                                        buildItemSender(snapshot.data[index])
                                                      : buildItemReceiver(snapshot.data[index])
                    );
                }
              }
            )
          ),

          Container(
            child: Row(
              children: <Widget>[
                // EditText
                Flexible(
                  child: Container(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText:  Strings.messageTextfield,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                ),
                // SendButton
                Material(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => sendMessage(textEditingController.text),
                      color: Colors.greenAccent,
                    ),
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
          
        ],
      )
    );

    
  
  }
  /// widget that displays to right the messages sends by the current user
  /// with [greenAccent color]
  /// display also the [publication_date] to the message if the difference
  /// between the [public_date] and the [current_date] is more than 15 minutes
   Widget buildItemSender(Message message) {

     BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

      String formattedDate = "";
      DateTime now = DateTime.now();
      var diffMinute = now.difference(message.publicationDate).inMinutes;
      if(diffMinute >= 15) {
        formattedDate = DateFormat(' d MMM, kk:mm').format(message.publicationDate);
      }
    return Column(
      children: <Widget>[
        Container(
          child: Bubble(
            style: styleMe,
            child: Text(message.content),
          ),
           
          ),
          
          Text(formattedDate),
      ],
    );
  }
  /// widget that displays to lef the messages received by the current user
  /// with [grey color]
  /// display also the [publication_date] to the message if the difference
  /// between the [public_date] and the [current_date] is more than 15 minutes
  Widget buildItemReceiver(Message message) {

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
      String formattedDate = "";
      DateTime now = DateTime.now();
      var diffMinute = now.difference(message.publicationDate).inMinutes;
      if(diffMinute >= 15) {
        formattedDate = DateFormat(' d MMM, kk:mm').format(message.publicationDate);
      }
    return Column(
      children: <Widget>[
        Container(
          child: Bubble(
            style: styleSomebody,
            child: Text(message.content),
          ),
           
          ),
          
          Text(formattedDate),
      ],
    );
  }

  
  
}