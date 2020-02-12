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



class ActivityPage extends StatefulWidget {

  final Activity activity;

  ActivityPage({Key key, @required this.activity});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {

  String location = "";

  @override
  void initState() {
    super.initState();
    loadLocation();
  }
  
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
              Text(
                "Between ${DateFormat.yMMMd().format(widget.activity.beginDate)} and ${DateFormat.yMMMd().format(widget.activity.endDate)}".toUpperCase(), 
                style: TextStyle(fontWeight: Dimens.weightBold, color: Theme.of(context).textTheme.body1.color.withOpacity(0.4)),
              ),
              FlexSpacer.small(),
              Text(
                widget.activity.title,
                style: Theme.of(context).textTheme.title,
              ),
              FlexSpacer(),
              Text(widget.activity.description),
              FlexSpacer(),
              Text(location),
              SizedBox(
                height: 200,
                child: GoogleMap(
                  compassEnabled: false,
                  circles: {
                    Circle(
                      circleId: CircleId("circle"),
                      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      strokeColor: Theme.of(context).colorScheme.primary,
                      center: LatLng(
                        widget.activity.location.latitude, widget.activity.location.longitude
                      ),
                      radius: 5000,
                      strokeWidth: 5
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    zoom: 10,
                    target: LatLng(
                     widget.activity.location.latitude, widget.activity.location.longitude
                  )),
                  markers: {
                    Marker(
                      markerId: MarkerId("marker"),
                      position: LatLng(
                        widget.activity.location.latitude, widget.activity.location.longitude
                      )
                    )
                  },
                  zoomGesturesEnabled: true,
                ),
              ),
              Text(
                "Discuss with the host for the exact location",
                style: Theme.of(context).textTheme.caption,
              )
              
            ],
          ),
        ),
      ),
    );
  }

  loadLocation() async {
    var placemarks = await Geolocator().placemarkFromPosition(widget.activity.location);
    if (placemarks.isNotEmpty) {
      var place = placemarks[0];
      print(place.toJson());
      setState(() => location = place.subLocality + ", " + place.locality + ", " + place.country);
    }
  }

  handleParticipation(context) {
    showSnackbar(
      context: context, 
      content: Text(Strings.availableSoon),
      critical: true,
    );
  }
}