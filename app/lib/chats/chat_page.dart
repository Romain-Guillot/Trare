import 'package:app/activities/activity_page.dart';
import 'package:app/chats/chat_service.dart';
import 'package:app/chats/messages/messages_page.dart';
import 'package:app/chats/messages/messages_provider.dart';
import 'package:app/chats/participants/participants_page.dart';
import 'package:app/chats/participants/participants_provider.dart';
import 'package:app/service_locator.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/widgets/activities_widgets.dart';
import 'package:app/shared/widgets/error_widgets.dart';
import 'package:app/shared/widgets/flat_app_bar.dart';
import 'package:app/shared/widgets/flex_spacer.dart';
import 'package:app/shared/widgets/info_widget.dart';
import 'package:app/shared/widgets/loading_widgets.dart';
import 'package:app/user/profile_service.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



/// Display the chat associated to the [activity]
/// 
/// It will display either a chat, of a widget to indicate that the user
/// participation is not yet validated (or error / loading widget)
///
/// The widget root is a [MultiProvider] to declare the following providers :
///   - [ParticipantsProvider] to get the praticipants / requests
///   - [MessagesProvider] to get the messages
/// 
/// Depending on the [ParticipantsProvider] state, tho following widget will
/// be displayed :
///   - participants and interested users are loaded : two cases :
///       - the connected user is a participant or the creator : [ActivityCommunicationLayout]
///       - the connected user is just interested : [ParticipationRequestNotAccepted]
///   - loading : [LoadingWidget]
///   - error or idle : [ErrorWidgetWithReload]
class ActivityCommunicationPage extends StatelessWidget {

  final Activity activity;

  ActivityCommunicationPage({
    Key key, 
    @required this.activity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ParticipantsProvider>(
          create: (_) => ParticipantsProvider(
            activity: activity,
            communicationService: locator<IActivityCommunicationService>(),
            profileService: locator<IProfileService>(),
          )..init(),
        ),
        ChangeNotifierProvider<MessagesProvider>(
          create: (_) => MessagesProvider(
            activity: activity,
            communicationService: locator<IActivityCommunicationService>()
          )..init(),
        )
      ],

      child: Scaffold(
        appBar: FlatAppBar(title: Text(activity.title),),
        body: SafeArea(
          child: Builder(
            builder: (context) => Consumer<ParticipantsProvider>(
              builder: (_, commProvider, __) {
                switch (commProvider.state) {
                  case PaticipantsProviderState.loaded:
                    switch (commProvider.userGroup) {
                      case UserGroup.participant:
                      case UserGroup.creator:
                        return ActivityCommunicationLayout(
                          activityCommunication: commProvider.activityCommunication
                        );
                      
                      case UserGroup.interested:
                      case UserGroup.unknown:
                      default:
                        return ParticipationRequestNotAccepted(
                          activity: activity,
                        );
                    }
                    break;

                  case PaticipantsProviderState.inProgress:
                    return LoadingWidget();

                  case PaticipantsProviderState.idle:
                  case PaticipantsProviderState.error:
                  default:
                    return ErrorWidgetWithReload(
                      message: Strings.chatUnableToLoad,
                      onReload: ( ) => commProvider.init()
                    );
                }
              }
            ),
          ),
        ),
      )
    );
  }
}



/// 
///
///
class ActivityCommunicationLayout extends StatelessWidget {

  final ActivityCommunication activityCommunication;

  ActivityCommunicationLayout({
    Key key, 
    @required this.activityCommunication
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Padding(
            padding: Dimens.screenPaddingBodyWithAppBar,
            child: TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              labelColor: Theme.of(context).colorScheme.primary,
              indicator: BoxDecoration(
                borderRadius: Dimens.borderRadius,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
              ),
              tabs: <Widget>[
                chatTab(),
                detailsTab(context),
              ]
            ),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                MessagesPage(), // replace with your widget
                ChatParticipantsPage(
                  activityCommunication: activityCommunication,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget chatTab() => Tab(
    icon: Icon(Icons.chat)
  );

  Widget detailsTab(context) => Consumer<ParticipantsProvider>(
    builder: (_, provider, __) {
      var nbInterested = provider.activityCommunication?.interestedUsers?.length;
      return Badge(
        showBadge: nbInterested != null && nbInterested >= 1,
        badgeColor: Theme.of(context).colorScheme.error,
        badgeContent: Text(
          nbInterested?.toString()??"", 
          style: TextStyle(color: Theme.of(context).colorScheme.onError)
        ),
        child: Tab(
          icon: Icon(Icons.info)
        )
      );
    }
  );
}



///
///
///
class ParticipationRequestNotAccepted extends StatelessWidget {

  final Activity activity;

  ParticipationRequestNotAccepted({
    Key key, 
    @required this.activity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: Dimens.screenPaddingBodyWithAppBar,
          child: Column(
          children: <Widget>[
            InfoCardWidget(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(Strings.participationNotYetAccepted),
                  FlexSpacer(),
                  Text(Strings.participationNotYetAcceptedStayTuned)
                ],
              ),
            ),
            FlexSpacer(),
            ItemActivity(
              activity: activity,
              onPressed: () => openActivity(context),
            ),
          ],
        ),
      )
    );
  }

  openActivity(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ActivityPage(activity: activity),
    ));
  }
}