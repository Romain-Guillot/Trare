// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO

import 'dart:math';

import 'package:app/models/activity.dart';

abstract class IActivitiesRepository{
  Future<List<Activity>> getActivities();
}


class FirestoreActivitiesRepository implements IActivitiesRepository {

  @override
  Future<List<Activity>> getActivities() async {
    await Future.delayed(Duration(seconds: Random().nextInt(3)));
    return _mockAtivities;
  }
}