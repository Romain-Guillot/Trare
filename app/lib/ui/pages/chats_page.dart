import 'package:app/logic/user_chats_provider.dart';
import 'package:app/ui/pages/activity_communication_details.dart';
import 'package:app/ui/pages/activity_communication_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/error_widgets.dart';
import 'package:app/ui/widgets/loading_widgets.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';




class ChatsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: Dimens.screenPadding,
              child: PageHeader(
                title: Text("My chats"),
              ),
            ),
            Consumer<UserChatsProvider>(
              builder: (_, chatsProvider, __) {
                switch (chatsProvider.state) {
                  case UserChatsState.loaded:
                    return Expanded(
                      child: ListItemsActivities(
                        activities: chatsProvider.activities,
                        onItemTap: (a) => openChat(context, a),
                      ),
                    );

                  case UserChatsState.inProgress:
                    return LoadingWidget();
                  
                  case UserChatsState.idle:
                  case UserChatsState.error:
                  default:
                    return ErrorWidgetWithReload(
                      message: "Cannot load",
                      onReload: () => chatsProvider.init(),
                    );
                }
              }
            )
            
          ],
        ),
      )
    );
  }

  openChat(context, activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ActivityCommunicationPage(activity: activity),
    ));
  }
}