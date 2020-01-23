import 'package:app/logic/authentication_provider.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthenticationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Values.screenMargin),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Icon(Icons.ac_unit, size: 60, color: Colors.blue,),

                Text("Welcome,"),
                Text("Ready to share activities with travellers arround you ?"),

                Expanded(child: Container()),

                AuthenticationButton(
                  providerMethod: Strings.googleProvider,
                  leadingIcon: null,
                  onPressed: () => handleGoogle(context),
                ),
                SizedBox(height: 15),
                AuthenticationButton(
                  providerMethod: Strings.facebookProvider,
                  leadingIcon: null,
                  onPressed: () => handleGoogle(context),
                ),
                SizedBox(height: 15),
                AuthenticationButton(
                  providerMethod: Strings.emailProvider,
                  leadingIcon: null,
                  onPressed: () => handleGoogle(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleGoogle(context) {
    Provider.of<AuthenticationProvider>(context, listen: false).handleGoogleConnexion();
  }

}



/// A Widget to build button for the authentication.
/// 
/// It displays a suffix sentences (e.g. "Continue with") followed by the 
/// authentication provider method (e.g. "Google" / "Facebook" / etc.).
/// 
/// NOTE:
/// It's a little tricky to show a button (with out custom) box shadow as we 
/// have to use [InkWell] and [Container] widget but the InWell widget splash 
/// only on [Material] widget (it's a the material theming rule), we need to 
/// have the following widgets nesting widget structure : 
///   Container -> Material -> InkWell -> Container
/// 1. The first Container define the color;
/// 2. The Material is required to apply to splash effect;
/// 3. The InkWell effect is our button behavior;
/// 4. The last Widget (here a Container) is our button content.
/// 
/// see : https://github.com/flutter/flutter/issues/3782 for more information 
/// about this behavior.
class AuthenticationButton extends StatelessWidget {

  final Function onPressed;
  final Icon leadingIcon;
  final String providerMethod;

  AuthenticationButton({Key key, @required this.onPressed, @required this.providerMethod, @required this.leadingIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white,
          boxShadow: [Values.shadow]
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.button,
                child: RichText(
                  text: TextSpan(
                    text: Strings.buttonProviderSuffixText,
                    style: Theme.of(context).textTheme.button.copyWith(fontWeight: Values.weightRegular),
                    children: [
                      TextSpan(
                        text: " " + providerMethod,
                        style: TextStyle(fontWeight: Values.weightBold)
                      )
                    ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}