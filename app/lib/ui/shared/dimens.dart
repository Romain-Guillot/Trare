import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// Useful constant values share across the app 
/// 
/// 
/// (e.g. padding, font size, font weight, margin, etc.)
/// Everything is constant, so the constructor is private
/// as it makes no sense to create an instance of this class.
class Dimens {
  Dimens._();

  // General values

  static const double screenPaddingValue = 17;
  static const EdgeInsets screenPadding = const EdgeInsets.all(screenPaddingValue);
  static const double smallSpacing = 5;
  static const double normalSpacing = 15;
  static const double bigSpacing = 45;

  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.normal;
  static const FontWeight weightBold = FontWeight.w700;

  static final BorderRadius rounedBorderRadius = BorderRadius.circular(999);
  static const double radius = 7;
  static final BorderRadius borderRadius = BorderRadius.circular(radius);

  static const BoxShadow shadow = BoxShadow(
    color: Color(0x22000000), // color of the shadow
    blurRadius: 5, // gaussian attenuation
    spreadRadius: 2 // shadow size
  );

  static const formMultiLinesDefaultLinesNumber = 10;




  // Authentication (prefix with "auth")
  static const double authLogoSize = 100;
  static const double authTitleSize = 35;
  static const double authDescriptionSize = 20;


  // Profile
  static const int maxImageResolution = 720;
  static const int profileDescriptionFormLineNumber = 5;

  // Activity
  static const double activityViewMapRatio = 4/3;

}