import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// Useful constant values share across the app (e.g. padding, font size,
/// font weight, margin, etc.)
class Values {
  Values._();

  static const double screenMargin = 17;

  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.normal;
  static const FontWeight weightBold = FontWeight.w700;



  static const shadow = BoxShadow(
    color: Color(0x22000000), // color of the shadow
    blurRadius: 5, // gaussian attenuation
    spreadRadius: 2 // shadow size
  );

}