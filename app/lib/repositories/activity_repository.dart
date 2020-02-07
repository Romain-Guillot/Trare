// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO

import 'package:app/models/activity.dart';

abstract class IActivityRepository{

  Activity getActivity();
  Activity editActivity(Activity activity);
}

class MockActivityRepository implements IActivityRepository{
  var activity1=Activity(
    title: "Randonée",
    location: "Montreal",
    duration: "2 jours",
    urlPhoto: "" );
  @override
  Activity editActivity(Activity activity) {
    // TODO: implement editActivity
    return null;
  }

  @override
  Activity getActivity() {
    
    return activity1;
  }
  }