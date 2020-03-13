// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/logic/activity_explore_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/activity_service_mock.dart';
import '../mocks/shared_models.dart';
import '../mocks/user_location_service_mock.dart';


/// Unit tests for [ActivityExploreProvider]
void main() {
  group("ActivityExploreProvider", () {
    var mockActivityService = MockActivityService();
    var mockUserLocationService = MockLocationService();

    test("Initial state", () {
      var provider = ActivityExploreProvider(
        activitiesService: mockActivityService,
        locationService: mockUserLocationService,
      );
      mockActivityService.willReturnError = false;
      mockUserLocationService.willReturnError = false;
      
      expect(provider.state, ActivityExploreProviderState.idle);
      expect(provider.activities, isNull);
      expect(provider.config.radius, defaultRadius);
    });

    bool listenerCalled = false;
    var listener = () => listenerCalled = true;

    test("Activities returned normally", () async {
      var provider = ActivityExploreProvider(
        activitiesService: mockActivityService,
        locationService: mockUserLocationService,
      );
      mockActivityService.willReturnError = false;
      mockUserLocationService.willReturnError = false;
      provider.addListener(listener);

      for (int i = 0; i<2 ; i++) {
        var future = provider.loadActivities();
        expect(provider.state, ActivityExploreProviderState.inProgress);
        await future;

        expect(provider.state, ActivityExploreProviderState.loaded);
        expect(provider.activities.length, 2);
        expect(provider.activities.first, a1);
        expect(provider.config.position, mockUserLocationService.position);
        expect(provider.config.radius, defaultRadius);
        expect(listenerCalled, true);

        provider.state = ActivityExploreProviderState.error;
        provider.activities = null;
        listenerCalled = false;
      }
    });

    listenerCalled = false;

    test("Database error occured caused by IActivityService", () async {
      var provider = ActivityExploreProvider(
        activitiesService: mockActivityService,
        locationService: mockUserLocationService,
      );
      mockActivityService.willReturnError = true;
      mockUserLocationService.willReturnError = false;
      provider.addListener(listener);

      for (int i = 0; i<2 ; i++) {
        var future = provider.loadActivities();
        expect(provider.state, ActivityExploreProviderState.inProgress);
        await future;

        expect(provider.state, ActivityExploreProviderState.error);
        expect(provider.activities, isNull);
        expect(provider.config.position, mockUserLocationService.position);
        expect(provider.config.radius, defaultRadius);
        expect(listenerCalled, true);

        provider.state = ActivityExploreProviderState.loaded;
        provider.activities = [a1];
        listenerCalled = false;
      }
    });

    test("Database error occured caused by ILocationService", () async {
      var provider = ActivityExploreProvider(
        activitiesService: mockActivityService,
        locationService: mockUserLocationService,
      );
      mockActivityService.willReturnError = false;
      mockUserLocationService.willReturnError = true;
      provider.addListener(listener);
      
      for (int i = 0; i<2 ; i++) {
        var future = provider.loadActivities();
        expect(provider.state, ActivityExploreProviderState.inProgress);
        await future;

        expect(provider.state, ActivityExploreProviderState.locationPermissionNotGranted);
        expect(provider.activities, isNull);
        expect(provider.config.radius, defaultRadius);
        expect(listenerCalled, true);

        provider.state = ActivityExploreProviderState.loaded;
        provider.activities = [a1];
        listenerCalled = false;
      }
    });
  });
}