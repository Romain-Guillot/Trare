// Authors: Romain Guillot and Mamadou Diouldé Diallo

import 'package:app/logic/activity_explore_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/activity_service_mock.dart';
import '../mocks/user_location_service_mock.dart';


void main() {
  group("description", () {
    var mockActivityService = MockActivityService();
    var mockUserLocationService = MockLocationService();

    test("Initial state", () {
      var provider = ActivityExploreProvider(
        activitiesService: mockActivityService,
        locationService: mockUserLocationService,
      );
      expect(provider.state, ActivityExploreProviderState.idle);
      expect(provider.activities, isNull);
      expect(provider.config.radius, defaultRadius);
    });

    test("Activities returned normally", () async {
      var provider = ActivityExploreProvider(
        activitiesService: mockActivityService,
        locationService: mockUserLocationService,
      );
      await provider.loadActivities();
      expect(provider.state, ActivityExploreProviderState.loaded);
    });
  });
}