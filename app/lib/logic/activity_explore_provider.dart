// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
// Tests: Done
import 'package:app/models/activity.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/user_location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';


/// Default radius to look for activities near a position (near = radius)
final defaultRadius = 300.0;



/// Config used to perfom query to the database
///
/// e.g. it can be viewed as parameters for a where clause, such a query in
/// english :
///   "activities whose position is within [radius] of position [position]."
class ActivitiesConfig {
  double radius;
  Position position;
  ActivitiesConfig({this.radius, this.position});
}



/// State to represent the provider state
enum ActivityExploreProviderState {
  idle,
  loaded,
  inProgress,
  locationPermissionNotGranted,
  error,
}



/// Used to retrieve activities that that may be relevant to the user.
///
/// It's a [ChangeNotifier] so it can notify clients (UI typically) when
/// changment occured. In praticular the provider holds three properties that
/// can be interesting for the UI :
///   - [config] the current [ActivitiesConfig] used to perform the search
///   - [state] the current provider state
///   - [activities] the list of activities results of a database query
/// 
/// If state is [ActivityExploreProviderState.loaded] the [activities] will
/// NOT be null. Else, it can (and will probably) be null.
class ActivityExploreProvider extends ChangeNotifier {

   final IActivityService _activityService;
   final IUserLocationService _locationService;

   final config = ActivitiesConfig(radius: defaultRadius);

   var _state = ActivityExploreProviderState.idle;
   ActivityExploreProviderState get state => _state;
   set state(value) {
     _state = value;
     notifyListeners();
   }
   List<Activity> activities;


  ActivityExploreProvider({
    @required IActivityService activitiesService,
    @required IUserLocationService locationService,
  }) : this._activityService = activitiesService,
       this._locationService = locationService;


  /// Load activities near the user and notify clients
  ///
  /// Use [config] for the following parameters :
  ///   - the position where to look for activities
  ///   - the max radius in which retrieve activities
  /// 
  /// If the config position is null, we'll use the user location
  /// 
  /// [activities] list and [state] will be updated and clients notified
  loadActivities() async {
    state = ActivityExploreProviderState.inProgress;
    var userPosition = await _locationService.retrieveUserPosition();
    if (userPosition == null) {
      state = ActivityExploreProviderState.locationPermissionNotGranted;
    } else {
      config.position = userPosition;
      try {
        this.activities = await _activityService.retreiveActivities(
          position: config.position,
          radius: config.radius,
        ); // null never returned
        state = ActivityExploreProviderState.loaded;
      } catch (_) {
        state = ActivityExploreProviderState.error;
      }
    }
  }
}
