import 'package:app/activities/activity_creation_page.dart';
import 'package:app/activities/activity_page.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/utils/geocoding.dart';
import 'package:app/shared/widgets/flex_spacer.dart';
import 'package:app/shared/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:app/main.dart';


/// Display a list of activities
/// 
/// Take this [activities] list as parameter and display each activity in a
/// [ItemActivity]
/// 
/// When the user tap on an activity item, it will open it in a new page :
/// [ActivityPage]
/// If you want to override this behavior you can provide you own [onItemTap]
/// function
class ListItemsActivities extends StatelessWidget {

  final List<Activity> activities;
  final Function(Activity) onItemTap;

  ListItemsActivities({
    Key key, 
    @required this.activities,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (_, position) {
        var activity = activities[position];
        return ItemActivity(
          activity: activity,
          onPressed: onItemTap == null
          ? () => openActivity(context, activity)
          : () => onItemTap(activity)
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
/// It simulate the [ListTile] layout with the title of the activity, the 
/// location, the dates and the user profile picture are trailing icon.
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
    var theme = Theme.of(context);
    var textLightColor = theme.textTheme.caption.color;
    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.screenPaddingValue,
          vertical: Dimens.normalSpacing
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (widget.activity.isEnded)
                        ...[
                        ActivityEndedBadge(),
                        FlexSpacer.small()
                        ],
                      Expanded(
                        child: _getText(
                          widget.activity.title,
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                  _getText(
                    location??Strings.unknownLocation,
                    style: theme.textTheme.bodyText2.copyWith(color: textLightColor),
                  ),
                  _getText(
                    dates,
                    style: theme.textTheme.bodyText2.copyWith(color: textLightColor),
                  )
                ],
              ),
            ),
            FlexSpacer.small(),
            SizedBox(
              height: Dimens.profilePictureSizeInListItem,
              width: Dimens.profilePictureSizeInListItem,
              child: ProfilePicture(
                url: widget.activity.user?.urlPhoto,
                rounded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getText(text, {style}) => Text(
    text,
    style: style,
    maxLines: 1,
    softWrap: false,
    overflow: TextOverflow.fade,
  );
}



/// Badge to indicate that an activity is finished
class ActivityEndedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.warning,
        borderRadius: BorderRadius.circular(3)
      ),
      padding: EdgeInsets.all(3),
      child: Text(
        Strings.activityEnded, 
        style: TextStyle(
          color: theme.colorScheme.onWarning, 
          fontWeight: Dimens.weightBold, 
          fontSize: theme.textTheme.caption.fontSize
        ),
      ),
    );
  }
}



/// Floating action button to open the [ActivityCreationPage]
///
/// An extended floating action button with a label and an icon. The pressed
/// action push a new route to open the [ActivityCreationPage]
class AddActivityFAB extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.add),
      foregroundColor: Colors.white,
      label: Text(Strings.addActivity),
      onPressed: () => openActivityCreationPage(context),
    );
  }

  openActivityCreationPage(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ActivityCreationPage(),
    ));
  }
}