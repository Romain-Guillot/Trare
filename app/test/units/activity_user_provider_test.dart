// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/logic/activity_user_provider.dart';
import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

/// Unit tests for [ActivityUserProvider]
void main() async {
  group("description", () {
    var mockActivityService = MockActivityService();
    var mockProfileService = MockProfileService();

    test("Initial state", () {
      var provider = ActivityUserProvider(
        activityService: mockActivityService,
        profileService: mockProfileService,
      );
      expect(provider.state, ActivityUserProviderState.idle);
    });

    bool listenerCalled = false;
    var listener = () => listenerCalled = true;

    test("Activities normally returned", () async {
      var provider = ActivityUserProvider(
        activityService: mockActivityService,
        profileService: mockProfileService,
      );
      expect(provider.state, ActivityUserProviderState.idle);
      provider.addListener(listener);
      for (int i = 0; i < 2; i++) {
        await provider.loadActivities();

        expect(provider.state, ActivityUserProviderState.loaded);
        expect(provider.activities.length, 2);
        expect(provider.activities.elementAt(0), a1);
        expect(provider.activities.elementAt(1), a2);
        expect(listenerCalled, isTrue);

        listenerCalled = false;
        provider.activities = null;
        provider.state = ActivityUserProviderState.error;
      }
    });
      
    listenerCalled = false;
    test("Database error occured caused by IActivityService", () async {
      mockActivityService.willReturnError = true;
      var provider = ActivityUserProvider(
          activityService: mockActivityService,
          profileService: mockProfileService,
        );
      provider.addListener(listener);
      await Future.delayed(Duration(microseconds: 100));

      for (int i = 0; i < 2; i++) {
        await provider.loadActivities();

        expect(provider.state, ActivityUserProviderState.error);
        expect(provider.activities, isNull);
        expect(listenerCalled, isTrue);

        listenerCalled = false;
        provider.activities = [a1];
        provider.state = ActivityUserProviderState.loaded;
      }
    });

    listenerCalled = false;
    test("Database error occured caused by IProfileService", () async {
      mockProfileService.willReturnError = true;
      var provider = ActivityUserProvider(
          activityService: mockActivityService,
          profileService: mockProfileService,
        );
      provider.addListener(listener);
      await Future.delayed(Duration(microseconds: 100));

      for (int i = 0; i < 2; i++) {
        await provider.loadActivities();

        expect(provider.state, ActivityUserProviderState.error);
        expect(provider.activities, isNull);
        expect(listenerCalled, isTrue);

        listenerCalled = false;
        provider.activities = [a1];
        provider.state = ActivityUserProviderState.loaded;
      }
    });
  });
  
}

final user = User(uid: "uid");

final a1 = Activity(
  title: "a1",
  beginDate: DateTime.fromMicrosecondsSinceEpoch(0),
  endDate: DateTime.fromMicrosecondsSinceEpoch(10000),
  createdDate: DateTime.fromMicrosecondsSinceEpoch(0),
  description: "a1 descr",
  location: Position(longitude: 50, latitude: 100),
  user: user
);

final a2 = Activity(
  title: "a2",
  beginDate: DateTime.fromMicrosecondsSinceEpoch(100),
  endDate: DateTime.fromMicrosecondsSinceEpoch(500),
  createdDate: DateTime.fromMicrosecondsSinceEpoch(10),
  description: "a2 descr",
  location: Position(longitude: 0, latitude: 0),
  user: user
);


class MockActivityService implements IActivityService {

  bool willReturnError = false;


  @override
  Future<Activity> createActivity(Activity activity) 
  => throw UnimplementedError();

  @override
  Future<List<Activity>> retreiveActivities({Position position, double radius}) 
  => throw UnimplementedError();

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


class MockProfileService implements IProfileService {  
  bool willReturnError = false;


  @override
  Future<User> editUser(User user)
  => throw UnimplementedError();

  @override
  Future<User> getUser({String userUID}) async {
    if (willReturnError)
      throw Exception();
    return user;
  }
}