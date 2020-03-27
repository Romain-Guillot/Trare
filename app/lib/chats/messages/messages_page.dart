
import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


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
     bool isSenderMessage(Message message) {
       return message.user == provider.user;
     }

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
       Text("Nothing to send");
    }

  }
    return Scaffold(
      body: Column(
        children: <Widget>[
          // buildListMessages
          //buildListMessage(messages),

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
                    itemBuilder: (context, index) => (snapshot.data[index].user == provider.user) ?
                                                      buildItemSender(snapshot.data[index])
                                                      : buildItemReceiver(snapshot.data[index]),
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
  /// widget that display a message 
  /// if the de difference between the [publication_date] and the current date 
  /// is more than 15 minutes the widget display also the date else the 
  /// [publication_date] will not display
  /// Display the messages send by me to the right with [color] and the messages
  /// messages received to the left
   Widget buildItemSender(Message message) {
      String formattedDate = "";
      DateTime now = DateTime.now();
      var diffMinute = now.difference(message.publicationDate).inMinutes;
      if(diffMinute >= 15) {
        formattedDate = DateFormat(' d MMM, kk:mm').format(message.publicationDate);
      }
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            message.content,
            style: TextStyle(color: Colors.white),
          ) ,
           padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
          ),
          
          Text(formattedDate),
      ],
    );
  }

  Widget buildItemReceiver(Message message) {
      String formattedDate = "";
      DateTime now = DateTime.now();
      var diffMinute = now.difference(message.publicationDate).inMinutes;
      if(diffMinute >= 15) {
        formattedDate = DateFormat(' d MMM, kk:mm').format(message.publicationDate);
      }
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            message.content,
            style: TextStyle(color: Colors.white),
          ) ,
           padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                  alignment: Alignment.topLeft,
          ),
          
          Text(formattedDate),
      ],
    );
  }

   Widget buildListMessage(Stream<List<Message>> messages) {
    return Flexible(
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
                   itemBuilder: (context, index) => buildItemReceiver(snapshot.data[index]),
                   );
               }
             },
           )
    );

  }

  
}