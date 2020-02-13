import 'package:app/services/activity_service.dart';
import 'package:app/services/authentication_service.dart';
import 'package:app/services/profile_service.dart';
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
    () => FirestoreActivityService()
  );
}