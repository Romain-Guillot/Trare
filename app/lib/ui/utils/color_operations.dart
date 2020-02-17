import 'dart:math';
import 'package:flutter/painting.dart';


/// Class to perform operations on [Color]
class ColorOperations {
  /// darken the [color], [amount] between 0 and 1
  static Color darken(Color color, [double amount = 0.5]) {
    final hslCol = HSLColor.fromColor(color);
    return hslCol.withLightness(max(hslCol.lightness - amount, 0)).toColor();
  }

  /// lighten the [color], [amount] between 0 and 1
  static Color lighten(Color color, [double amount = 0.5]) {
    final hslCol = HSLColor.fromColor(color);
    return hslCol.withLightness(min(hslCol.lightness + amount, 1)).toColor();
  }
}