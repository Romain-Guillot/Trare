// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done.
// Tests: TODO

import 'package:app/models/activity.dart';
import 'package:app/repositories/activity_repository.dart';
import 'package:flutter/cupertino.dart';

class ActivityProvider extends ChangeNotifier{
   IActivityRepository _activityRepository;
   List<Activity> listActivity=[];

  Activity _activity;
  Activity get activity => _activity;

  ActivityProvider({
    @required IActivityRepository activityRepository
  }):this._activityRepository=activityRepository;
  set activity(Activity newActivity){
    assert(newActivity!=null);
   _activity=newActivity;
   listActivity.add(_activity);
   notifyListeners();
  }

  /*List<Activity> listActivity=[];

  addActivityInList(){
    Activity _activity=Activity(
      title: "Randonée au mont tremblant",
      duration: "2 jours",
      location: "Montreal",
      urlPhoto: " " );
    listActivity.add(_activity);
    notifyListeners();
  }*/


  
}