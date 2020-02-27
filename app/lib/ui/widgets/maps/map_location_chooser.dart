import 'dart:math';

import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/maps/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



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
    return Flexible(
      child: ClipRRect(
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
      )
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