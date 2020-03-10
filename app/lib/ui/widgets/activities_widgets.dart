import 'package:app/models/activity.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/geocoding.dart';
import 'package:app/ui/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Display a list of activities
/// 
/// Take this [activities] list as parameter and display each activity in a
/// [ItemActivity]
/// 
/// When the user tap on an activity item, it will open it in a new page :
/// [ActivityPage]
class ListItemsActivities extends StatelessWidget {

  final List<Activity> activities;

  ListItemsActivities({Key key, @required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (_, position) {
        var activity = activities[position];
        return ItemActivity(
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
    @required this.activity,
    this.onPressed
  });

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
    if (widget.activity.location != null)
      Geocoding().locationReprFromPosition(widget.activity.location)
          .then((location) {
            if (mounted) setState(() => this.location = location);
          });
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimens.screenPaddingValue,
      ),
      isThreeLine: true, // title, location, date
      title: Text(widget.activity.title),
      subtitle: Text("${location??Strings.unknownLocation}\n$dates"),
      trailing: LayoutBuilder(
        builder: (_, constraints) => SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxHeight,
          child: ProfilePicture(
            url: widget.activity.user?.urlPhoto,
            rounded: true,
          ),
        )
      ),
      onTap: widget.onPressed,
    );
  }
}