

import 'package:app/logic/activity_chat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ActivityCommunicationChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityChatProvider> (
      builder: (_, provider, __) {
        switch(provider.state) {

          case ActivityChatState.loadedMessages:
          
          case ActivityChatState.loaded:
            // TODO: Handle this case.
            break;
          case ActivityChatState.inProgress:
            // TODO: Handle this case.
            break;
          case ActivityChatState.error:
            // TODO: Handle this case.
            break;
        }

      }

      );
  }

  reloadActivityChat(context) {
    var provider = Provider.of<ActivityChatProvider>(context, listen: false);
    provider.init();
  }

}