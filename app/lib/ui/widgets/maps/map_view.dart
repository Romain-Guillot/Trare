import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



/// Google map view centered in a specific location with a precision circle
///
/// It will rendered a Google map view centered in the [position] with a circle
/// around centered in the [position] to highlight the area.
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

      // To consume all touch event (especially to intercept events when this 
      // widget is in a scrollable widget.
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      ].toSet(),
    );
  }
}