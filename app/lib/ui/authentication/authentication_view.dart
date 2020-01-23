import 'package:app/logic/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthenticationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Google"),
              onPressed: () => handleGoogle(context),
            ),
            RaisedButton(
              child: Text("Facebook"),
              onPressed: null,
            ),
            RaisedButton(
              child: Text("Email"),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  handleGoogle(context) {
    Provider.of<AuthenticationProvider>(context, listen: false).handleGoogleConnexion();
  }

}