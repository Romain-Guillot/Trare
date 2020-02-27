// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: Done (not need...)


import 'package:app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';


class Activity {
  String title;
  User user;
  String description;
  DateTime createdDate;
  DateTime beginDate;
  DateTime endDate;
  Position location;

  Activity({
    @required this.title,
    @required this.user,
    @required this.description,
    @required this.createdDate,
    @required this.beginDate,
    @required this.endDate,
    @required this.location,
  }); 
}