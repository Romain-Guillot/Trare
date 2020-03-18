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


// TODO(dioul) : tu peux completer cette instance fictive pour tester
// ton UI
final mockActivityCommunication = ActivityCommunication(
  activity: mockActivity,
  participants: [User(name: "Paul", age: 17), User(name: "Jena", age: 34), User(name: "Dania", age: 65), User(name: "Mike", age: 56)],
  interestedUsers: [User(name: "Robert", age: 21, uid:"5"), User(name: "Jean", age: 56, uid:"6")],
  messages: [],
);


class ActivityCommunicationPage extends StatelessWidget {

  final Activity activity;

  ActivityCommunicationPage({
    Key key, 
    @required this.activity
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityCommunicationProvider(
        activity: activity,
        communicationService: locator<IActivityCommunicationService>()
      )..load(),
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
                    children: <Widget>[
                      Text("TODO DIOUL"), // replace by your widget
                      ActivityCommunicationDetails(),
                    ],
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