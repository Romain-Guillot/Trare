import 'package:app/logic/authentication_provider.dart';
import 'package:app/repositories/authentication_repository.dart';
import 'package:app/ui/authentication/authentication_view.dart';
import 'package:app/ui/authentication/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAuthenticationRepository authRepo = FirebaseAuthenticationRepository();
  await authRepo.signOut();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(create: (context) => AuthenticationProvider(
        authenticationRepository: authRepo
      ))
    ],
    child: MyApp())
  );
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
