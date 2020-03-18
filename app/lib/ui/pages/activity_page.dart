import 'package:app/models/activity.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/geocoding.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/maps/map_view.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:app/ui/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';



/// Main page to display an [activity]
///
/// It displays information about an activity such as the title, the 
/// description, the user, etc.
/// 
/// The layout is pretty simple, it is composed of 2 elements :
///   - the app bar
///   - the body
/// 
/// The app bar contains a button to initiate the communication system between 
/// the current user and the activity owner. See [ParticipationButton]
/// 
/// The body is simply a scroll view with the useful information about the 
/// activity.
class ActivityPage extends StatelessWidget {

  final Activity activity;

  ActivityPage({@required this.activity});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlatAppBar(
        action: ParticipationButton()
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: Dimens.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ActivityViewHeader(
                activity: activity
              ),
              FlexSpacer(),
              UserCard(
                user: activity.user,
                isClickable: true,
              ),
              FlexSpacer(),
              ActivityDescription(
                description: activity.description,
              ),
              FlexSpacer(),
              ActivityLocation(
                position: activity.location,
              )
            ],
          ),
        ),
      ),
    );
  }
}



/// Button to initiate the communication system
///
/// It will initiate the communication system between the current user (the 
/// user who click on this button) and the creator of the activity.
class ParticipationButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Button(
        child: Text(Strings.iAmInterested),
        onPressed: () => handleParticipation(context),
    );
  }

  handleParticipation(context) {
    showSnackbar(
      context: context, 
      content: Text(Strings.availableSoon),
      critical: true,
    );
  }
}



/// The header of the activity with the title and the dates
class ActivityViewHeader extends StatelessWidget {

  final Activity activity;

  ActivityViewHeader({@required this.activity});

  @override
  Widget build(BuildContext context) {
    var dateRange = Strings.activityDateRange(activity.beginDate, activity.endDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (activity.isEnded)
          ...[
            ActivityEndedBadge(),
            FlexSpacer.small(),
          ],
        if (dateRange != null)
          ...[
            Text(
              dateRange.toUpperCase(), 
              style: TextStyle(
                fontWeight: Dimens.weightBold, 
                color: Theme.of(context).textTheme.caption.color
              ),
            ),
            FlexSpacer.small(),
          ],
        PageHeader(
          title: Text(activity.title),
        ),
      ],
    );
  }
}



/// Display the activity description, or an empty container if no description
class ActivityDescription extends StatelessWidget {

  final String description;

  ActivityDescription({@required this.description});

  @override
  Widget build(BuildContext context) {
    return description == null 
      ? Container()
      : Text(description);
  }
}



/// Display the activity location, or an empty container if no description
///
/// It displays two elements :
///   - a textual representation of the loation (country, city, etc)
///     thanks to the [Geocoding] class
///   - A map representation of the location thansk to [GoogleMapView]
class ActivityLocation extends StatefulWidget {

  final Position position;

  ActivityLocation({@required this.position});

  @override
  _ActivityLocationState createState() => _ActivityLocationState();
}

class _ActivityLocationState extends State<ActivityLocation> {

  String location = Strings.activityViewLoadingPos;

  @override
  void initState() {
    super.initState();
    if (widget.position != null)
      Geocoding().locationReprFromPosition(widget.position)
          .then((location) => setState(() => this.location = location));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.position == null)
      return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(location??Strings.unknownLocation),
        LayoutBuilder(
          builder: (_, constraints) => SizedBox(
            height: constraints.maxWidth / Dimens.activityViewMapRatio,
            child: GoogleMapView(position: widget.position,)
          ),
        ),
        Text(
          Strings.activityMapViewCaption,
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }
}