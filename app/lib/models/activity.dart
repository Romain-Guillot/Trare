// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: TODO


import 'package:app/models/user.dart';
import 'package:geolocator/geolocator.dart';


class Activity {
  String title;
  User user;
  String description;
  DateTime createdDate;
  DateTime beginDate;
  DateTime endDate;
  Position location;
}