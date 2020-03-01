import 'package:app/ui/shared/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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