import 'package:app/chats/chat_service.dart';
import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/shared/models/activity.dart';
//import 'package:app/models/activity_communication.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/user/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class MessagesPage extends StatelessWidget {
  static  Activity activity;
  static IProfileService _profileService;
  static IActivityCommunicationService communicationService = FirestoreActivityCommunicationService(profileService: _profileService);
   MessagesProvider messagesProvider = new MessagesProvider(activity: activity, communicationService: communicationService);
  

  MessagesPage({Key key, @required this.messagesProvider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(messagesProvider: this.messagesProvider),
    );


  
  }



}

class ChatScreen extends StatefulWidget {
   final MessagesProvider messagesProvider;

   ChatScreen({Key key, @required this.messagesProvider}) : super(key: key);

  @override
  State createState() => new ChatScreenState(messages: MessagesProvider.messages);

}

class ChatScreenState extends State<ChatScreen> {
  final Stream<List<Message>> messages;
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  ChatScreenState({Key key, @required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
        ],
      ),
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

  Widget buildListMessage() {
    return Flexible(
      child: messages == null 
           ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
           : StreamBuilder(
             stream: messages,
             builder: (context, snapshot) {
               if(!snapshot.hasData) {
                 return Center(
                   child: CircularProgressIndicator(),
                 );
               } else {
                 return ListView.builder(
                   padding: EdgeInsets.all(10.0),
                   itemBuilder: (context, index) => buildItem(snapshot.data),
                   );
               }
             },
           )
    );

  }


}

