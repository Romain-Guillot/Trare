import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/geocoding.dart';
import 'package:app/ui/widgets/location_permission_requester.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/activity.dart';


/// this is the principal widget that show all the awailable activity
class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListItemsActivities(),
        ),
      )
    );
  }
}

class ListItemsActivities extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityExploreProvider>(
      builder: (_, activityProvider, __) {
        Widget body; 
        var state=activityProvider.state;
      switch(state){
        case ActivityProviderState.loadingInProgress: 
            body=LoadInprogressWidget(); 
            break;
        case ActivityProviderState.databaseError: 
            body=DatabaseErrorWidget();
            break;
        case ActivityProviderState.locationPermissionNotGranted:
            body=LocationPermissionRequester(
              textInformation: Strings.locationPermissionInfo,
              onPermissionGranted: () => loadActivites(context),
              );
            break;
        
        default: 
        body=ListView.builder(
            shrinkWrap: true,
            itemCount: activityProvider.activities.length,
            itemBuilder: (_, position) {
              var activity = activityProvider.activities[position];
              return ItemActivityWidget(
                key: GlobalKey(),
                activity: activity,
                onPressed: () => openActivity(context, activity),
              );
            } 
          );
        break;

      }
      
        return Column(
          children: <Widget>[
            LocationPermissionRequester(
              textInformation: Strings.locationPermissionInfo,
              onPermissionGranted: () => loadActivites(context),
            ),
            body
          ],
        );        
      }
    );
  }


  openActivity(context, activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ActivityPage(activity: activity)
    ));
  } 


  loadActivites(context) {
    Provider.of<ActivityExploreProvider>(context, listen: false).loadActivities();
  }
}

/// this is a simple [CircularProgressIndicator] that will be displayed when the state of our [ActiviyExploreProvider] is LoadingInprogress
class LoadInprogressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
      backgroundColor: Colors.amber,
      semanticsLabel: Text("Please wait...").toString(),
      semanticsValue: Text("Please wait...").toString(),  
    ),
    );
  }
}

/// this is a simple widget that will be displayed when the state of our [ActiviyExploreProvider] LocationPermissionNotGrant 
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
class ItemActivityWidget extends StatefulWidget {

  final Activity activity;
  final Function onPressed;

  ItemActivityWidget({
    Key key,
    @required this.activity,
    this.onPressed
  }) : super(key: key);

  @override
  _ItemActivityWidgetState createState() => _ItemActivityWidgetState();
}

class _ItemActivityWidgetState extends State<ItemActivityWidget> {
  
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
      subtitle: Text("$location\n$dates\n"),
      onTap: widget.onPressed,
    );
  }
}