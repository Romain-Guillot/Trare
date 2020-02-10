// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO

import 'dart:math';

import 'package:app/models/activity.dart';

abstract class IActivityRepository{
  Future<List<Activity>> getActivities();
}


class MockActivityRepository implements IActivityRepository {

  var _mockAtivities = [
    Activity(
      title: "Randonée",
      location: "Montreal",
      duration: "2 jours",
      urlPhoto: "" 
    ),
    Activity(
      title: "Club",
      location: "Montreal",
      duration: "3 jours",
      urlPhoto: "" 
    ),
  ];


  @override
  Future<List<Activity>> getActivities() async {
    await Future.delayed(Duration(seconds: Random().nextInt(3)));
    return _mockAtivities;
  }
}