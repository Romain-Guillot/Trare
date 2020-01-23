import 'package:app/logic/authentication_provider.dart';
import 'package:app/ui/shared/assets.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class AuthenticationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(Values.screenMargin),
          child: Stack(
            children: [

              SingleChildScrollView(child: AuthenticationHeader()),

              Positioned(
                bottom: 0, left: 0, right: 0, // bottom centered
                child: Center(child: AuthenticationButtonList())
              )
            ]
          ),
        ),
      ),
    );
  }
}


class AuthenticationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SvgPicture.asset(
          Assets.logo, 
          height: 100, 
          color: Theme.of(context).colorScheme.primary,
        ),

        Text("Welcome,"),
        Text("Ready to share activities with travellers arround you ?"),
      ],
    );
  }
}


class AuthenticationButtonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AuthenticationButton(
          providerMethod: Strings.googleProvider,
          leadingIcon: SvgPicture.asset(Assets.google),
          onPressed: () => handleGoogle(context),
        ),
        SizedBox(height: 15),
        AuthenticationButton(
          providerMethod: Strings.facebookProvider,
          leadingIcon: SvgPicture.asset(Assets.facebook),
          onPressed: () => null,
        ),
        SizedBox(height: 15),
        Text("OR"),
        SizedBox(height: 15),
        AuthenticationButton(
          providerMethod: Strings.emailProvider,
          leadingIcon: SvgPicture.asset(Assets.mail),
          onPressed: () => null,
        ),
      ],
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
  final Widget leadingIcon;
  final String providerMethod;

  AuthenticationButton({Key key, @required this.onPressed, @required this.providerMethod, @required this.leadingIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(height: 24, width: 24, child: leadingIcon),
                DefaultTextStyle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}