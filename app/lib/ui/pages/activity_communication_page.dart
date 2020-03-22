import 'package:app/logic/activity_chat_provider.dart';
import 'package:app/logic/activity_communication_provider.dart';
import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/service_locator.dart';
import 'package:app/services/activity_communication_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:app/ui/pages/activity_communication_details.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/error_widgets.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/info_widget.dart';
import 'package:app/ui/widgets/loading_widgets.dart';
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
        ChangeNotifierProvider<ActivityCommunicationProvider>(
          create: (_) => ActivityCommunicationProvider(
            activity: activity,
            communicationService: locator<IActivityCommunicationService>(),
            profileService: locator<IProfileService>(),
          )..init(),
        ),
        ChangeNotifierProvider<ActivityChatNotifier>(
          create: (_) => ActivityChatNotifier(
            activity: activity,
            communicationService: locator<IActivityCommunicationService>()
          )..init(),
        )
      ],

      child: Scaffold(
        appBar: FlatAppBar(title: Text(activity.title),),
        body: SafeArea(
          child: Builder(
            builder: (context) => Consumer<ActivityCommunicationProvider>(
              builder: (_, commProvider, __) {
                switch (commProvider.state) {
                  case ActivityCommunicationState.loaded:
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

                  case ActivityCommunicationState.inProgress:
                    return LoadingWidget();

                  case ActivityCommunicationState.idle:
                  case ActivityCommunicationState.error:
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
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Consumer<ActivityCommunicationProvider>(
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
                Text("TODO DIOUL"), // replace with your widget
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