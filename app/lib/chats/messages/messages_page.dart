
import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
     provider.init();
     var messages = provider.messages;
    return Scaffold(
      body: Column(
        children: <Widget>[
          // buildListMessages
          buildListMessage(messages),

          // buildInput
          buildInput(),
        ],
      )
    );

    
  
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible (
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.amber, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: Strings.messageTextfield,
                  hintStyle: TextStyle(color: Colors.grey)
                  ),
                  focusNode: focusNode,
              ),
            ),
          ),
          

            // Button send message
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => {},
                  color: Colors.amber,
                  ),
                
              ),
              color: Colors.white,
            ),

          
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: new BorderSide(color: Colors.amber, width: 0.5)), color: Colors.white ),
      );
    
  }

   Widget buildItem(Message message) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            message.content,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            message.publicationDate.toString(),
            style: TextStyle(color: Colors.redAccent),
          )
        ],
      ),
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
                   itemBuilder: (context, index) => buildItem(snapshot.data[index]),
                   );
               }
             },
           )
    );

  }
}