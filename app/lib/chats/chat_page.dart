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
            communicationService: locator<IActivityCommunicationService>(),
            profileService: locator<IProfileService>(),
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
                        return RequestValidationWaiting(
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
                      message: "Unable to load data",
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



class ActivityCommunicationLayout extends StatelessWidget {

  final ActivityCommunication activityCommunication;
  final MessagesProvider messagesProvider;

  ActivityCommunicationLayout({
    Key key, 
    @required this.activityCommunication, this.messagesProvider
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
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Consumer<ParticipantsProvider>(
                  builder: (_, provider, __) {
                    var nbInterested = provider.activityCommunication?.interestedUsers?.length;
                    return Badge(
                      badgeContent: Text(nbInterested?.toString()??"", style: TextStyle(color: Theme.of(context).colorScheme.onError)),
                      showBadge: nbInterested != null && nbInterested >= 1,
                      badgeColor: Theme.of(context).colorScheme.error,
                      child: Tab(icon: Icon(Icons.info))
                    );
                  }
                ),
              ]
            ),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                MessagesPage(
                  activityCommunication: activityCommunication,
                ), // replace with your widget
                ActivityCommunicationDetails(
                  activityCommunication: activityCommunication,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}



class RequestValidationWaiting extends StatelessWidget {

  final Activity activity;

  RequestValidationWaiting({
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
                  Text("The user who created the activity has to validate your participation request."),
                  FlexSpacer(),
                  Text("Stay tuned !")
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