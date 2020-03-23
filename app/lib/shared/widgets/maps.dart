import 'dart:math';

import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/res/values.dart';
import 'package:app/shared/widgets/flex_spacer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



// To consume all touch event (especially to intercept events when this 
// widget is in a scrollable widget.
final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
  Factory<OneSequenceGestureRecognizer>(
    () => EagerGestureRecognizer(),
  )].toSet();


final double defaultZoom = Values.mapDefaultZoom;


final double circleSize = Values.mapCircleRadius;


Circle createCircle(BuildContext context, LatLng position) {
    var circleBorderColor = Theme.of(context).colorScheme.primary;
    var circleColor = circleBorderColor.withOpacity(0.3);
  return  Circle(
    circleId: CircleId("circle"),
    fillColor: circleColor,
    strokeColor: circleBorderColor,
    center: position,
    radius: circleSize,
    strokeWidth: 5
  );
}


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


/// [FormField] to choose a location on the [GoogleMap] widget
///
/// TODO(romain)
class GoogleMapLocationField extends FormField<Position> {

  GoogleMapLocationField({
    Key key,
    @required String label,
    bool required = false
  }) : super(
    key: key,
    validator: (position) => 
        position == null && required ? Strings.requiredMap : null,
    builder: (state) {
      var context = state.context;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: Theme.of(context).inputDecorationTheme.labelStyle
          ),
          FlexSpacer.small(),
          LayoutBuilder(
            builder: (_, constraints) => SizedBox(
              height: constraints.maxWidth,
              child: GoogleMapLocationChooser(
                onPositionSelected: (latlong) {
                  state.didChange(Position(
                    latitude: latlong.latitude,
                    longitude: latlong.longitude
                  ));
                },
              ),
            )
          ),
          if (state.hasError)
            Text(
              state.errorText,
              style: Theme.of(context).inputDecorationTheme.errorStyle
            )
        ]
      );
    }
  );
}



/// TODO(romain)
class GoogleMapLocationChooser extends StatefulWidget {

  final Function(LatLng) onPositionSelected;

  GoogleMapLocationChooser({@required this.onPositionSelected});

  @override
  _GoogleMapLocationChooser createState() => _GoogleMapLocationChooser();
}

class _GoogleMapLocationChooser extends State<GoogleMapLocationChooser> {

  GoogleMapController controller;
  LatLng position;
  double currentZoom;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: Dimens.borderRadius,
      child: GoogleMap(
        compassEnabled: false,
        initialCameraPosition: CameraPosition(target: LatLng(0,0)),
        onMapCreated: (controller) => this.controller = controller,
        circles: {
          if (position != null)
            createCircle(context, position)
        },
        zoomGesturesEnabled: true,
        onTap: onPlaceMarker,
        onCameraMove: (cameraPosition) => currentZoom = cameraPosition.zoom,
        gestureRecognizers: gestureRecognizers
      ),
    );
  }

  onPlaceMarker(LatLng newPosition) {
    setState(() => position = newPosition);
    widget.onPositionSelected(newPosition);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: newPosition,
      zoom: max(currentZoom??0, defaultZoom)
    )));
  }
}