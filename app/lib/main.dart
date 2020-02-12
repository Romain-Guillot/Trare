import 'package:app/logic/activity_provider.dart';
import 'package:app/logic/authentication_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/repositories/activity_repository.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:app/ui/activity/activity_view.dart';
import 'package:app/ui/authentication/authentication_view.dart';
import 'package:app/ui/authentication/loading_view.dart';
import 'package:app/ui/home/explore.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/profile/profile_visualisation_view.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




/// Entry point for the app.
/// 
/// First, we create our repositories that will be used by our providers. So
/// our providers will only deal with interfaces instead of concreate 
/// implementations. And normally repositories have to be instantiated only
/// here acconrding to the app architecture (see documentation) as there
/// are only the providers that deal with the repositories.
/// 
/// Then, we inflate out main widget app and attach it to the screen thanks to
/// the [runApp] method (framework method). Our root widget is a 
/// [MultiProvider] that contains all our providers that can be used in the app
/// to deal with the business logic.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var authRepo = FirebaseAuthenticationRepository();
  var profileRepo = FiresoreProfileRepository();
  var activityRepo = FirestoreActivitiesRepository();

  var authProvider = AuthenticationProvider(authRepo: authRepo)..init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(create: (context) => 
        authProvider
      ),
      ChangeNotifierProvider<ProfileProvider>(create: (context) => 
        ProfileProvider(
          profileRepo: profileRepo,
          authenticationProvider: authProvider
        )
      ),
      ChangeNotifierProvider<ActivityProvider>(create: (context) => 
        ActivityProvider(
          activityRepository: activityRepo
        )
      )
    ],
    child: MyApp()
  ));
}



/// Main widget for our app (if we don't consider the [MultiProvider] widget 
/// that wrapped our app).
/// 
/// It builds a [MaterialApp] to defines our app (with title, theme, and so on)
/// 
/// The content of our app is defined according to the [AuthenticationProvider]
/// state. So a [Consumer] widget is used to listen the [AuthenticationProvider]
/// state changes : 
///   - if the authentication provider is not initialized we display a loading
///     screen ([LoadingView])
///   - if the authentication provider is initialized and no user is logged, we
///     build the [AuthenticationView] widget
///   - if the user is logged, we go to the homepage
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,

      theme: appTheme,

      home: Consumer<AuthenticationProvider>(
        builder: (context, authenticationProvider, child) {
          if (!authenticationProvider.isInitialized)
            return LoadingView();
          if (authenticationProvider.user == null)
            return AuthenticationView();
          else {
            //return ProfileVisualisationView();
            return MyHomePage();
          }
        }
      ),
    );
  }
}


extension ColorSchemeExt on ColorScheme {
  Color get onSurfaceLight => Colors.black.withOpacity(0.3);
}


/// Theme defined for our app (color, text style, etc)
/// We can use this constants anywhere in our app by using
/// [Theme.of(context)...], for example to know what is our error color :
/// [Theme.of(context).colorScheme.error]
/// 
/// See https://api.flutter.dev/flutter/material/ThemeData-class.html to know
/// more about all theme values.
final appTheme = ThemeData(
  primaryColor: Color(0xff1FD59F),

  colorScheme: ColorScheme(
    primary: Color(0xff1FD59F),
    primaryVariant: Color(0xff1FD59F),
    onPrimary: Colors.white,

    secondary: Color(0xff),
    secondaryVariant: Color(0xff),
    onSecondary: Color(0xff),

    surface: Color(0xffe6e6e6),
    onSurface: Color(0xff000000),

    error: Color(0xfffc3d46),
    onError: Colors.white,

    background: Colors.white,
    onBackground: Colors.black,

    brightness: Brightness.light,
  ),

  backgroundColor: Colors.white,
  splashColor: Colors.white,

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(fontSize: 15, fontWeight: Dimens.weightBold)
  ),

  textTheme: TextTheme(
    title: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
    subtitle: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 15, fontWeight: Dimens.weightBold),
    body1: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),

    display1: TextStyle(fontSize: Dimens.authDescriptionSize, color: Colors.black.withOpacity(0.5))
  ),

  buttonTheme: ButtonThemeData(
    minWidth: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))
  )
);
