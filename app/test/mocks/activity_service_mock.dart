// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/activities/activity_service.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/user.dart';
import 'package:geolocator/geolocator.dart';

import 'shared_models.dart';


class MockActivityService implements IActivityService {

  bool willReturnError = false;

  @override
  Future<Activity> createActivity(Activity activity) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Activity>> retreiveActivities({Position position, double radius}) async {
    await Future.delayed(Duration(microseconds: 100));
    if (willReturnError)
      throw Exception();
    return [
      a1,
      a2
    ];
  }

  @override
  Future<List<Activity>> retreiveActivitiesUser({User user}) async {
    await Future.delayed(Duration(microseconds: 100));
    if (willReturnError)
      throw Exception();
    return [
      a1,
      a2
    ];
  }
}
