import 'package:app/logic/authentication_provider.dart';
import 'package:app/ui/shared/assets.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/values.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


/// Root widget for the authentication (==> authentication screen)
/// 
/// It's simply a [Scaffold] with only a body (not app bar, floating action
/// button, etc.). As UI description in Flutter favors composition over 
/// inheritance, the widget tree is deep !! So the tree is split into simple
/// widget (it also improve the reusability as the widget have a single
/// responsability).
/// 
/// So this [AuthenticationView] has the following widget tree :
///   - [AuthenticationView] (root)
///   |---- [AuthenticationHeader] (some information as the app logo)
///   |---- [AuthenticationButtonList] (the list of buttons to log in)
/// 
/// Note: widgets for controls, positioning, styles, ... are not representing 
///       in this documentation as they have no semantic meaning 
///       (e.g. : Stack, Padding, Positionned)
/// 
/// The AuthenticationHeader and the AuthenticationButtonList are put inside a 
/// [Stack] widget. 
/// The AuthenticationHeader is put inside a [SingleScrollView], it can be seen
/// as the main content of this widget, if there are a lot of information, the
/// user can scroll to display all the information (or if the devices screen is
/// small).
/// The AuthenticationButtonList is put inside a [Positioned] widget and above
/// the AuthenticationHeader (as it is the second on the Stack list). It is 
/// positionned at the bottom-center of the widget.
/// 
/// Q: Why this structure ?
/// A: With this structure, the AuthenticationButtonList is always visible by 
/// the user (as it is always positionned at the bottom-center of the screen). 
/// It makes sense as it is the main purpose of this widget to provide an 
/// authentication system. The AuthenticationHeader is behind the 
/// AuthenticationButtonList and it can be scrolled if needed to see all the 
/// information (note that some information can be hide by the 
/// AuthenticationButtonList, but it can be resolve by adding a padding of the
/// size of the AuthenticationButtonList, but we want to keep this widget as 
/// simple as possible so for now I think it's best to keep this behavior).
/// 
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
              SingleChildScrollView(
                child: AuthenticationHeader()
              ),
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



/// Simple widget to show some "start up" information about our app.
///
/// This widget displays the following elements :
/// - our app logo
/// - a title
/// - a description
class AuthenticationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SvgPicture.asset(
          Assets.logo, 
          height: Values.authLogoSize, 
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: Values.screenMargin),
        Text(
          Strings.authenticationTitle,
          style: TextStyle(fontSize: Values.authTitleSize, fontWeight: Values.weightBold)
        ),
        Text(
          Strings.authenticationDescription,
          style: TextStyle(fontSize: Values.authDescriptionSize, color: Colors.black.withOpacity(0.5))
        ),
      ],
    );
  }
}



/// List of all buttons to authenticate the user.
/// 
/// It reflect the 3 methods supporting by our repository :
///  - with Google
///  - with Facebook
///  - with email / password
/// 
/// So it's a [Column] of three [AuthenticationButton] that reprensents the 3
/// authentication methods listed above.
/// 
/// If an error occured during the authentication process, a [Snackbar] is
/// displayed.
class AuthenticationButtonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AuthenticationButton(
          providerMethod: Strings.googleProvider,
          leadingIcon: SvgPicture.asset(Assets.google),
          onPressed: () => _handleGoogle(context),
        ),
        SizedBox(height: 15),
        AuthenticationButton(
          providerMethod: Strings.facebookProvider,
          leadingIcon: SvgPicture.asset(Assets.facebook),
          onPressed: () => _handleFacebook(context),
        ),
        SizedBox(height: 15),
        Text(Strings.alternativeAuthenticationMethodeSeparotor),
        SizedBox(height: 15),
        AuthenticationButton(
          providerMethod: Strings.emailProvider,
          leadingIcon: SvgPicture.asset(Assets.mail),
          onPressed: () => null,
        ),
      ],
    );
  }

  _handleGoogle(context) {
    Provider.of<AuthenticationProvider>(context, listen: false)
      .handleGoogleConnexion()
      .catchError((e) => _showError(context));
  }

  _handleFacebook(context){
    Provider.of<AuthenticationProvider>(context, listen: false)
      .handleFacebookConnexion()
      .catchError((e) => _showError(context));
  }

  _showError(context) {
    showSnackbar(
      context: context,
      content: Text(Strings.authenticationError),
      critical: true
    );
  }
}



/// A Widget that represents a button for the authentication.
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

  static const double _padding = 15;

  final Function onPressed;
  final Widget leadingIcon;
  final String providerMethod;

  AuthenticationButton({
    Key key, 
    @required this.onPressed, 
    @required this.providerMethod, 
    @required this.leadingIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).textTheme.button;
    final iconSize = buttonStyle.fontSize * 1.5; //  icons are 1.5 times bigger than the text
    return Container(
      decoration: BoxDecoration(
        borderRadius: Values.rounedBorderRadius,
        color: Colors.white,
        boxShadow: [Values.shadow]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Values.rounedBorderRadius,
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(_padding),
            child: Wrap(
              spacing: _padding,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(height: iconSize, width: iconSize, child: leadingIcon),
                DefaultTextStyle(
                  style: buttonStyle,
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