import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/logic/activity_user_provider.dart';
import 'package:app/logic/authentication_provider.dart';
import 'package:app/logic/permissions_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/logic/user_chats_provider.dart';
import 'package:app/service_locator.dart';
import 'package:app/services/activity_communication_service.dart';
import 'package:app/services/activity_service.dart';
import 'package:app/services/authentication_service.dart';
import 'package:app/services/profile_service.dart';
import 'package:app/services/user_location_service.dart';
import 'package:app/ui/pages/app_layout.dart';
import 'package:app/ui/pages/authentication_page.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/error_widgets.dart';
import 'package:app/ui/widgets/loading_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';





/// Entry point for the app.
/// 
/// Services used in the app are initialized with [setupServiceLocator()], it
/// will use `get_it` package to simulate DI.
/// 
/// Then we launch the app thanks to the [runApp()] convenient method. We wrap
/// the app inside a [ChangeNotifierProvider] to provide the 
/// [AuthenticationProvivder] down the tree to handle the authenatication
/// business logic.
/// 
/// Note : the providers used in the app (except this authentication provider)
/// are declared in [MyApp] widget. We declared our providers in [MyApp] because
/// it will recreate new providers evertimes the user status changes (so after
/// every log in, it will recreate new provider to not keep dirty states)
/// 
/// The app is [MyApp]
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();

  runApp(
    ChangeNotifierProvider<AuthenticationProvider>( 
      create: (_) => AuthenticationProvider(
        authService: locator<IAuthenticationService>()
      )..init(),
      child: MyApp()
    )
  );
}



/// Main widget for our app 
/// 
/// (if we don't consider the [MultiProvider] widget that wrapped our app).
/// 
/// It builds a [MaterialApp] to defines our app (with title, theme, and so on)
/// 
/// The content of our app is defined according to the [AuthenticationProvider]
/// state. So a [Consumer] widget is used to listen the [AuthenticationProvider]
/// state changes : 
///   - user connected => Homepage
///   - user not connected => Authentication page
///   - error occured => error page
///   - inprogress => loading page
/// 
/// We use [MyMaterialApp] widget to build our MaterialApp. This widget takes
/// the providers used by the material app. So it is here that we add the
/// app providers.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: Strings.appName,

      theme: appTheme,

      home: Consumer<AuthenticationProvider>(
        builder: (_, authProvider, __) {
          switch (authProvider.state) {
            case AuthProviderState.notconnected:
              return MyMaterialApp(
                child: AuthenticationPage(),
              );

            case AuthProviderState.connected:
              return MyMaterialApp(
                providers: [
                  ChangeNotifierProvider<ProfileProvider>( 
                    create: (_) => ProfileProvider(
                      profileService: locator<IProfileService>(),
                    )..loadUser()
                  ),
                  ChangeNotifierProvider<ActivityExploreProvider>(create: (context) => 
                    ActivityExploreProvider(
                      activitiesService: locator<IActivityService>(),
                      locationService: locator<IUserLocationService>()
                    )..loadActivities()
                  ),
                  ChangeNotifierProvider<ActivityUserProvider>(create: (context) =>
                    ActivityUserProvider(
                      activityService: locator<IActivityService>(), 
                      profileService: locator<IProfileService>() 
                    )..loadActivities()
                  ),
                  ChangeNotifierProvider<LocationPermissionProvider>(create: (context) => 
                    LocationPermissionProvider(
                      locationService: locator<IUserLocationService>()
                    )
                  ),
                  ChangeNotifierProvider<UserChatsProvider>(create: (context) =>
                    UserChatsProvider(
                      profileService: locator<IProfileService>(),
                      activityService: locator<IActivityService>(),
                      communicationService: locator<IActivityCommunicationService>() 
                    )..init()
                  ),
                ],
                child: AppLayout()
              );

            case AuthProviderState.inprogress:
              return LoadingPage();

            case AuthProviderState.error:
            default:
              return ErrorPage();
          }
        }
      ),
    );
  }
}


class MyMaterialApp extends StatelessWidget {

  final Widget child;
  final List<ChangeNotifierProvider> providers;

  MyMaterialApp({
    @required this.child, 
    this.providers
  });

  @override
  Widget build(BuildContext context) {
    return providers == null || providers.isEmpty
      ? MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          theme: appTheme,
          home: child
        )
      : MultiProvider(
          providers: providers,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: appTheme,
            home: child
          ),
        );
  }
}


extension ColorSchemeExt on ColorScheme {
  Color get onSurfaceLight => Colors.black.withOpacity(0.3);

  Color get info => Colors.yellow[100];
  Color get onInfo => Colors.yellow[900];

  Color get warning => Colors.orange[100];
  Color get onWarning => Colors.orange[900];
}


/// Theme defined for our app (color, text style, etc)
/// We can use this constants anywhere in our app by using
/// [Theme.of(context)...], for example to know what is our error color :
/// [Theme.of(context).colorScheme.error]
/// 
/// See https://api.flutter.dev/flutter/material/ThemeData-class.html to know
/// more about all theme values.
final appTheme = ThemeData(
  primaryColor: _primary,
  accentColor: _primary,

  colorScheme: ColorScheme(
    primary: _primary,
    primaryVariant: _primary,
    onPrimary: Colors.white,

    secondary: Color(0xff),
    secondaryVariant: Color(0xff),
    onSecondary: Color(0xff),

    surface: Color(0xffe6e6e6),
    onSurface: Color(0xff000000),

    error: _errorColor,
    onError: Colors.white,

    background: Colors.white,
    onBackground: Colors.black,

    brightness: Brightness.light,
  ),

  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  splashColor: Colors.white,

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(fontSize: 15, fontWeight: Dimens.weightBold),
    counterStyle: TextStyle(fontSize: 12),
    errorStyle: TextStyle(fontSize: 12, color: _errorColor)
  ),

  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontSize: 15,
      color: Colors.black.withOpacity(0.8)
    ),

    headline1: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.1,
      color: Colors.black
    ),

    subtitle1: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
      color: Colors.black
    ),

    subtitle2: TextStyle(
      fontSize: 15,
      fontWeight: Dimens.weightBold,
      letterSpacing: 0.25,
      color: Colors.black.withOpacity(0.35)
    )
  ),

  buttonTheme: ButtonThemeData(
    minWidth: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))
  )
);



Color _primary = Color(0xff1FD59F);
Color _errorColor = Color(0xfffc3d46);