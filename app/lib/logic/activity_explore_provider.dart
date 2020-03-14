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
  /// Nothing happened, activities are not loaded and loading is not in progress
  idle,
  
  /// Activities are loaded and can be accessed
  loaded,

  /// Activities loading are in progress
  inProgress,

  /// Activities cannot be loaded because of the permission location not granted
  locationPermissionNotGranted,
  
  /// An error occured to load the activities (e.g. database error)
  error,
}



/// Used to retrieve activities that that may be relevant to the user
/// 
/// An activity is considered as revelant if it is near the [config.prosition]
/// (near defined by [config.radius]).
/// 
/// It contains the following state :
/// - [state] : current state ofthe provider (see [ActivityExploreProviderState])
/// - [config] : last config used to retrieve the activities
/// - [activities] : relevant activities
/// 
/// The [activities] list is null if the activities are not yet loaded or if an 
/// error occured. Else, it is filled with the relevant activities.
/// 
/// When the [ActivityExploreProvider] is created, its state is 
/// [ActivityExploreProviderState.idle] and no process are triggered. Consider to
/// call the unique public method [loadActivities()] that will load the
/// activities AND notify clients when process finished.
///
/// It's a [ChangeNotifier] so it can notify clients (UI typically) when
/// changement occured (typically client will listen the [state] property)
/// 
/// Usage :
/// 
/// ```dart
/// // UI -> create ChangeNotifierProvider widget that wraps this provider
/// ChangeNotifierProvider<ActivityUserProvider>(create: (context) =>
///   ActivityExploreProvider(
///     activityService: ..., 
///     locationService: ...,
///   )..loadActivities()
/// ),
/// 
/// 
/// // UI -> Subscribe to the provider
/// Consumer<ActivityExploreProvider>(
///   builder: (context, provider, child) {
///     // here you can be notified when the provider state changed
///     // you can for example build widget acconrdingly by using a switch case
///     // statement
///   }
/// )
/// ```
class ActivityExploreProvider extends ChangeNotifier {

   final IActivityService _activityService;
   final IUserLocationService _locationService;

   final config = ActivitiesConfig(radius: defaultRadius);
   var state = ActivityExploreProviderState.idle;
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
    if (activities == null || activities.isEmpty)
      notifyListeners();
    var userPosition = await _locationService.retrieveUserPosition();
    if (userPosition == null) {
      state = ActivityExploreProviderState.locationPermissionNotGranted;
      activities = null;
    } else {
      config.position = userPosition;
      try {
        activities = await _activityService.retreiveActivities(
          position: config.position,
          radius: config.radius,
        ); // null never returned
        state = ActivityExploreProviderState.loaded;
      } catch (_) {
        state = ActivityExploreProviderState.error;
        activities = null;
      }
    }
    notifyListeners();
  }
}
