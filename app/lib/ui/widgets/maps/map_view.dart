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
/// 
/// There is also a button displayed at the bottom rigth corner that will recenter
/// the camera on the [position] with the default zoom.
class GoogleMapView extends StatefulWidget {

  final LatLng position;

  GoogleMapView({
    @required Position position
  }) : this.position = LatLng(position.latitude, position.longitude);

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {

  GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: Dimens.borderRadius,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
              zoom: defaultZoom,
              target: widget.position
            ),
            circles: {
              createCircle(context, widget.position)
            },
            zoomGesturesEnabled: true,
            gestureRecognizers: gestureRecognizers,
            onMapCreated: (c) => controller = c,
          ),
          Positioned(
            right: 0, bottom: 0,
            child: MaterialButton(
              child: Icon(Icons.location_searching),
              color: Colors.white,
              minWidth: 0,
              shape: CircleBorder(),
              onPressed: onRePositionned 
            ),
          )
        ],
      )
    );
  }

  onRePositionned() {
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: widget.position,
      zoom: defaultZoom
    )));
  }
}