import 'package:app/activities/activity_service.dart';
import 'package:app/authentication/authentication_service.dart';
import 'package:app/chats/chat_service.dart';
import 'package:app/shared/services/user_location_service.dart';
import 'package:app/user/profile_service.dart';
import 'package:get_it/get_it.dart';

/// Service locator to retrieve services
GetIt locator = GetIt.instance;

/// Register our services that can then be accessed anywhere with the 
/// service locator [locator]
/// 
/// ```dart
/// locator<IAuthenticationService>();
/// ```
void setupServiceLocator() {
  locator.registerLazySingleton<IAuthenticationService>(
    () => FirebaseAuthenticationService()
  );
  locator.registerLazySingleton<IProfileService>(
    () => FirestoreProfileService()
  );
  locator.registerLazySingleton<IActivityService>(
    () => FirestoreActivityService(profileService: locator<IProfileService>())
  );
  locator.registerLazySingleton<IUserLocationService>(
    () => UserLocationService()
  );
  locator.registerLazySingleton<IActivityCommunicationService>(
    () => FirestoreActivityCommunicationService(
      profileService: locator<IProfileService>()
    )
  );
}