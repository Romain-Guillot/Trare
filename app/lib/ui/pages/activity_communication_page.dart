import 'package:app/logic/activity_chat_provider.dart';
import 'package:app/logic/activity_communication_provider.dart';
import 'package:app/models/activity.dart';
import 'package:app/models/activity_communication.dart';
import 'package:app/models/user.dart';
import 'package:app/service_locator.dart';
import 'package:app/services/activity_communication_service.dart';
import 'package:app/ui/pages/activity_communication_details.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


final mockActivity = Activity(
  id: "4FiW8TngKJFlbjOW2C80",
  title: "Mock activity",
  description: "Mock description",
  beginDate: DateTime.now(),
  endDate: DateTime.now(),
  createdDate: DateTime.now(),
  location: Position(latitude: 0, longitude: 0),
  user: User(
    age: 21,
    name: "Mock user",
  )
);



class ActivityCommunicationPage extends StatelessWidget {

  final Activity activity;
  final List<Widget> pages = [
    Text("TODO DIOUL"), // replace with your widget
    ActivityCommunicationDetails(),
  ];

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
            communicationService: locator<IActivityCommunicationService>()
          )..init(),
        ),
        ChangeNotifierProvider<ActivityChatProvider>(
          create: (_) => ActivityChatProvider(
            activity: activity,
            communicationService: locator<IActivityCommunicationService>()
          )..init(),
        )
      ],

      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: FlatAppBar(title: Text(activity.title),),
          body: SafeArea(
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
                            showBadge: nbInterested != null,
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
                    children: pages
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}