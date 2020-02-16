import 'package:app/main.dart';
import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:app/ui/widgets/profile/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class ActivityPage extends StatelessWidget {

  final Activity activity;

  ActivityPage({@required this.activity});
  
  @override
  Widget build(BuildContext context) {
    var dateRange = Strings.activityDateRange(activity.beginDate, activity.endDate);
    return Scaffold(
      appBar: FlatAppBar(
        action: Builder(
          builder: (context) => Button(
            child: Text(Strings.iAmInterested),
            onPressed: () => handleParticipation(context),
          ),
        )        
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: Dimens.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (dateRange != null)
                Text(
                  dateRange.toUpperCase(), 
                  style: TextStyle(fontWeight: Dimens.weightBold, color: Theme.of(context).colorScheme.onSurfaceLight),
                ),
              FlexSpacer.small(),
              PageHeader(
                title: Text(activity.title),
              ),
              FlexSpacer(),
              UserCard(user: activity.user,),
              FlexSpacer(),
              if (activity.description != null)
                Text(activity.description),
              FlexSpacer(),
              if (activity.location != null)
                ActivityLocation(position: activity.location,)
            ],
          ),
        ),
      ),
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
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(location),
        LayoutBuilder(
          builder: (_, constraints) => SizedBox(
            height: constraints.maxWidth / (4/3),
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

  loadLocation() async {
    var placemarks = await Geolocator().placemarkFromPosition(widget.position);
    if (placemarks.isNotEmpty) {
      var place = placemarks[0];
      setState(() => {
        location = place.subLocality + ", " + place.locality + ", " + place.country
      });
    }
  }
}


class GoogleMapView extends StatelessWidget {

  final LatLng position;

  GoogleMapView({
    @required Position position
  }) : this.position = LatLng(position.latitude, position.longitude);

  @override
  Widget build(BuildContext context) {
    var circleBorderColor = Theme.of(context).colorScheme.primary;
    var circleColor = circleBorderColor.withOpacity(0.3);
    return GoogleMap(
      compassEnabled: false,
      initialCameraPosition: CameraPosition(
        zoom: 10,
        target: position
      ),
      circles: {
        Circle(
          circleId: CircleId("circle"),
          fillColor: circleColor,
          strokeColor: circleBorderColor,
          center: position,
          radius: 5000,
          strokeWidth: 5
        )
      },
      zoomGesturesEnabled: true,
    );
  }
}