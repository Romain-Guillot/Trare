import 'package:app/models/user.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/widgets/buttons.dart';
import 'package:app/ui/shared/widgets/flat_app_bar.dart';
import 'package:app/ui/shared/widgets/flex_spacer.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Activity {
  String title = "Randonnée au Mont Tremblant";
  String description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin hendrerit ligula eu malesuada ultricies. Morbi sed venenatis enim. Sed convallis egestas tristique. In quis enim eu ante porta dignissim. Sed velit est, consequat ac massa blandit, porttitor viverra urna. Aenean pretium sagittis enim non tempus. Morbi eget varius urna.";
  DateTime createdDate = DateTime.now();
  DateTime beginDate = DateTime(2020, 2, 10);
  DateTime endDate = DateTime(2020, 2, 15);
  User user;
  Position location = Position(latitude: 48.419124, longitude: -71.051799);

}


class ActivityView extends StatefulWidget {

  final Activity activity;

  ActivityView({Key key, @required this.activity});

  @override
  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {

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
              Text("Discuss with the host for the exact location")
              
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