import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/geocoding.dart';
import 'package:app/ui/widgets/location_permission_requester.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/activity.dart';



/// Page to display a list a activities that can be interesting for the user
/// 
/// It used the [ActivityExploreProvider] to retrieve this list of activities.
/// Depending on the provider state, it will display the follwing widget :
///   - the activities are loaded : [ListItemsActivities]
///   - activity loading in progress : [LoadInprogressWidget]
///   - a database error occured : [DatabaseErrorWidget]
///   - the location permission is not granted (but needed) : [LocationPermissionRequester]
class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: Dimens.screenPadding,
              child: PageHeader(
                title: Text(Strings.exploreTitle),
                subtitle: Text(Strings.exploreDescription),
              ),
            ),
            Consumer<ActivityExploreProvider>(
              builder: (_, activityProvider, __) {
                switch (activityProvider.state) {
                  case ActivityProviderState.loadingInProgress: 
                    return LoadInprogressWidget(); 
                  case ActivityProviderState.databaseError: 
                    return DatabaseErrorWidget();
                  case ActivityProviderState.locationPermissionNotGranted:
                    return LocationPermissionRequester(
                      textInformation: Strings.locationPermissionInfo,
                      onPermissionGranted: () => loadActivites(context)
                    );   
                  case ActivityProviderState.activitiesLoaded:
                  default: 
                    return ListItemsActivities(
                      activities: activityProvider.activities
                    );
                }
              }
            ),
          ],
        ),
      )
    );
  }

  loadActivites(context) {
    Provider.of<ActivityExploreProvider>(context, listen: false).loadActivities();
  }
}



/// Display a list of activities
/// 
/// Take this [activities] list as parameter and display each activity in a
/// [ItemActivity]
/// 
/// When the user tap on an activity item, it will open it in a new page :
/// [ActivityPage]
class ListItemsActivities extends StatelessWidget {

  final List<Activity> activities;

  ListItemsActivities({@required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (_, position) {
        var activity = activities[position];
        return ItemActivity(
          key: GlobalKey(),
          activity: activity,
          onPressed: () => openActivity(context, activity),
        );
      } 
    );
  }

  openActivity(context, activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ActivityPage(activity: activity)
    ));
  } 
}



/// this is a simple [CircularProgressIndicator] that will be displayed when the
/// state of our [ActiviyExploreProvider] is LoadingInprogress
class LoadInprogressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.amber,
        semanticsLabel: Strings.accessibilityLoadingLabel,
      ),
    );
  }
}



/// this is a simple widget that will be displayed when the state of our 
/// [ActiviyExploreProvider] LocationPermissionNotGrant 
class DatabaseErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.databaseErrorInfo),
    );
  }
}



/// List item to display information about an activity
///
/// It is a [ListTile] with the title of the activity, the location and the
/// dates.
/// 
/// It is a [Stateful] because the geocoding operation to retreive to 
/// location information (country, city, etc.) from a position (lat, lon) is
/// an asynchronous task. So when the location information is available
/// we display it.
/// 
/// You can provider the [onPressed] function to call a callback when the
/// used clicks on the activty item (to open it for example)
class ItemActivity extends StatefulWidget {

  final Activity activity;
  final Function onPressed;
  


  ItemActivity({
    Key key,
    @required this.activity,
    this.onPressed
  }) : super(key: key);

  @override
  _ItemActivityState createState() => _ItemActivityState();
}

class _ItemActivityState extends State<ItemActivity> {
  
  String get dates => Strings.activityDateRange(
    widget.activity.beginDate, 
    widget.activity.endDate
  );

  String location;


  @override
  void initState() {
    super.initState();
    // retrieve location information from the coordinates (async)
    Geocoding().locationReprFromPosition(widget.activity.location)
        .then((location) => setState(() => this.location = location));
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimens.screenPaddingValue,
      ),
      isThreeLine: true, // title, location, date
      title: Text(widget.activity.title),
      subtitle: Text("$location\n$dates"),
      onTap: widget.onPressed,
    );
  }
}