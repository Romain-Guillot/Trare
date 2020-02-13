import 'package:app/models/activity.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';



class ActivityPage extends StatelessWidget {

  final Activity activity;

  ActivityPage({@required this.activity});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlatAppBar(
        action: Button(
          child: Text("I'm interested"),
          onPressed: () => handleParticipation(context),
        )        
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: Dimens.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (activity.beginDate != null && activity.endDate != null)
                Text(
                  "Between ${DateFormat.yMMMd().format(activity.beginDate)} and ${DateFormat.yMMMd().format(activity.endDate)}".toUpperCase(), 
                  style: TextStyle(fontWeight: Dimens.weightBold, color: Theme.of(context).textTheme.body1.color.withOpacity(0.4)),
                ),
              FlexSpacer.small(),
              Text(
                activity.title,
                style: Theme.of(context).textTheme.title,
              ),
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

  String location = "";

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
        SizedBox(
          height: 200,
          child: GoogleMapView(position: widget.position,)
        ),
        Text(
          "Discuss with the host for the exact location",
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
    return GoogleMap(
      compassEnabled: false,
      circles: {
        Circle(
          circleId: CircleId("circle"),
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          strokeColor: Theme.of(context).colorScheme.primary,
          center: position,
          radius: 5000,
          strokeWidth: 5
        )
      },
      initialCameraPosition: CameraPosition(
        zoom: 10,
        target: position
      ),
      markers: {
        Marker(
          markerId: MarkerId("marker"),
          position: position
        )
      },
      zoomGesturesEnabled: true,
    );
  }
}