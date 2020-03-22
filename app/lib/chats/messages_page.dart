import 'package:app/chats/messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



class MessagesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider> (
      builder: (_, provider, __) {
        switch(provider.state) {
          case MessagesState.loadedMessages:
            return Text("LOADING");

          case MessagesState.loaded:
            return Text("LOADED");

          case MessagesState.inProgress:
              return Text("IN PROGRESS");
          case MessagesState.error:
          default:
            return Text("ERROR");
        }
      }
    );
  }

  reloadActivityChat(context) {
    var provider = Provider.of<MessagesProvider>(context, listen: false);
    provider.init();
  }

} 