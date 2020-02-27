import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/maps/map_utils.dart';
import 'package:flutter/foundation.dart';
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
    return ClipRRect(
      borderRadius: Dimens.borderRadius,
      child: GoogleMap(
        compassEnabled: false,
        initialCameraPosition: CameraPosition(
          zoom: defaultZoom,
          target: position
        ),
        circles: {
          createCircle(context, position)
        },
        zoomGesturesEnabled: true,
        gestureRecognizers: gestureRecognizers
      )
    );
  }
}