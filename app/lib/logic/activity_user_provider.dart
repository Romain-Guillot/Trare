// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: Done
// Tests: Done
import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter/cupertino.dart';


/// State to represent the provider state
enum ActivityUserProviderState {
  /// Nothing happened, activities are not loaded and loading is not in progress
  idle,

  /// Activities are loaded and can be accessed
  loaded,

  /// Activities loading are in progress
  loading,

  /// An error occured to load the activities (e.g. database error)
  error,
}



/// Provider used to load and read the activities created by the connected user
/// 
/// It contains the following state (public variables) :
/// - [state] representes the actual provider state (see [ActivityUserProviderState])
/// - [activities] the list of activities created by the user
///
/// The [activities] list is null if the activities are not yet loaded or if an 
/// error occured. Else, it is filled with the activity objects that represent
/// the activities created by the connected user.
/// 
/// When the [ActivityUserProvider] is created, its state is 
/// [ActivityUserProviderState.idle] and no process are triggered. Consider to
/// call the unique public method [loadActivities()] that will load the
/// activities AND notify clients.
/// 
/// Indeed, this provider is a [ChangeNotifier], so client can substribe to 
/// listen the [state].
/// 
/// Usage :
/// 
/// ```dart
/// // UI -> create ChangeNotifierProvider widget that wraps this provider
/// ChangeNotifierProvider<ActivityUserProvider>(create: (context) =>
///   ActivityUserProvider(
///     activityService: ..., 
///     profileService: ...,
///   )..loadActivities()
/// ),
/// 
/// 
/// // UI -> Subscribe to the provider
/// Consumer<ActivityUserProvider>(
///   builder: (context, provider, child) {
///     // here you can be notified when the provider state changed
///     // you can for example build widget acconrdingly by using a switch case
///     // statement
///   }
/// )
/// ```
class ActivityUserProvider extends ChangeNotifier {

  IActivityService _activityService;
  IProfileService _profileService;

  var state = ActivityUserProviderState.idle;
  List<Activity> activities;


  ActivityUserProvider({
    @required IActivityService activityService,
    @required IProfileService profileService,
  }) : this._activityService = activityService,
       this._profileService = profileService;


  /// Load activities created by the connected user
  /// 
  /// It also update the current [state] and notify listeners
  /// It first retreive the current connected user thanks to the [IProfileService]
  /// and then get the list of the activities created by this user thanks
  /// to [IActivityService]
  /// 
  /// When process finished (with success or failure), it will update the [state]
  /// and notify clients who subscribes
  loadActivities() async {
    state = ActivityUserProviderState.loading;

    var currentUser = await _getCurrentUser();

    if (currentUser == null) {
      state = ActivityUserProviderState.error;
      activities = null;
    } else {
      try {
        activities = await _activityService.retreiveActivitiesUser(user: currentUser);
        state = ActivityUserProviderState.loaded;
      } catch (_) {
        state = ActivityUserProviderState.error;
        activities = null;
      }
    }
    notifyListeners();
  }
  
  
  /// Returns the connected user or null if and error occured
  Future<User> _getCurrentUser() async {
    try {
      var user = await _profileService.getUser();
      return user;
    } catch (e) {
      return null;
    }
  }
}
