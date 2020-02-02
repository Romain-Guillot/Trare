import 'package:app/logic/authentication_provider.dart';
import 'package:app/ui/shared/assets.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/widgets/flex_spacer.dart';
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
/// The widget tree is wrapped inside a [LayoutBuilder] to render two different
/// layout depending on the actual [Orientation].
/// 
/// Note: the background image is only visible in the portait layout.
class AuthenticationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) => Container(
            height: constraint.maxHeight,
            padding: Dimens.screenPadding,
            child: OrientationBuilder(
              builder: (context, orientation) =>
              orientation == Orientation.portrait
              ? portraitLayout(constraint)
              : landscapeLayout()
            ),
          ),
        ),
      ),
    );
  }

/// The AuthenticationHeader and the AuthenticationButtonList are put inside a 
/// [Stack] widget. 
/// The AuthenticationButtonList is put inside a [Positioned] widget and above
/// the AuthenticationHeader (as it is the second on the Stack list). It is 
/// positionned at the bottom-center of the widget.
/// 
/// Q: Why this structure ?
/// A: With this structure, the AuthenticationButtonList is always visible by 
/// the user (as it is always positionned at the bottom-center of the screen). 
/// It makes sense as it is the main purpose of this widget to provide an 
/// authentication system. 
  Widget portraitLayout(constraint) {
    return Stack(
      children: [
        AuthenticationHeader(),
        Positioned(
            bottom: 0, left: 0, right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                height: constraint.maxHeight / 2,
                child: SvgPicture.asset(Assets.startup, fit: BoxFit.fitHeight)
              ),
            ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0, // bottom centered
          child: Center(child: AuthenticationButtonList())
        )
      ]
    );
  }

  /// The AuthenticationHeader and the AuthenticationButtonList are put inside
  /// a row, both element expands in the row (so same width)
  Widget landscapeLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          child: AuthenticationHeader(),
        ),
        Expanded(
          child: AuthenticationButtonList(),
        )
      ],
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
          height: Dimens.authLogoSize, 
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: Dimens.screenPaddingValue),
        Text(
          Strings.authenticationTitle,
          style: Theme.of(context).textTheme.display2
        ),
        Text(
          Strings.authenticationDescription,
          style: Theme.of(context).textTheme.display1
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AuthenticationButton(
          providerMethod: Strings.googleProvider,
          leadingIcon: SvgPicture.asset(Assets.google),
          onPressed: () => _handleGoogle(context),
        ),
        FlexSpacer(),
        AuthenticationButton(
          providerMethod: Strings.facebookProvider,
          leadingIcon: SvgPicture.asset(Assets.facebook),
          onPressed: () => _handleFacebook(context),
        ),
        FlexSpacer(),
        Text(Strings.alternativeAuthenticationMethodeSeparotor),
        FlexSpacer(),
        AuthenticationButton(
          providerMethod: Strings.emailProvider,
          leadingIcon: SvgPicture.asset(Assets.mail),
          onPressed: () => _handleEmail(context),
        ),
      ],
    );
  }

  _handleGoogle(context) {
    Provider.of<AuthenticationProvider>(context, listen: false)
      .handleGoogleLogin()
      .catchError((e) => _showError(context));
  }

  _handleFacebook(context){
    Provider.of<AuthenticationProvider>(context, listen: false)
      .handleFacebookLogin()
      .catchError((e) => _showError(context));
  }

  _handleEmail(context) {
    _showError(context);
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
        borderRadius: Dimens.rounedBorderRadius,
        color: Colors.white,
        boxShadow: [Dimens.shadow]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Dimens.rounedBorderRadius,
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
                      style: Theme.of(context).textTheme.button.copyWith(fontWeight: Dimens.weightRegular),
                      children: [
                        TextSpan(
                          text: " " + providerMethod,
                          style: TextStyle(fontWeight: Dimens.weightBold)
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