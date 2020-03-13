// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/logic/activity_user_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/activity_service_mock.dart';
import '../mocks/profile_service_mock.dart';
import '../mocks/shared_models.dart';


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
      expect(provider.activities, isNull);
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