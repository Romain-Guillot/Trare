import 'package:app/logic/authentication_provider.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:app/ui/authentication/authentication_view.dart';
import 'package:app/ui/authentication/loading_view.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



////
///
///
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAuthenticationRepository authRepo = FirebaseAuthenticationRepository();
  await authRepo.signOut();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(create: (context) => 
        AuthenticationProvider(
          authRepo: authRepo
        )..init()
      ),
    ],
    child: MyApp())
  );
}



///
///
///
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
          else
            return Text("Connected"); // TODO : sprint 2
        }
      ),
    );
  }
}



/// 
final appTheme = ThemeData(
  primaryColor: Color(0xff1FD59F),

  colorScheme: ColorScheme(
    primary: Color(0xff1FD59F),
    primaryVariant: Color(0xff1FD59F),
    onPrimary: Colors.white,

    secondary: Color(0xff),
    secondaryVariant: Color(0xff),
    onSecondary: Color(0xff),

    surface: Color(0xff),
    onSurface: Color(0xff),

    error: Color(0xff),
    onError: Color(0xff),

    background: Color(0xff),
    onBackground: Color(0xff),

    brightness: Brightness.light
  ),
);
