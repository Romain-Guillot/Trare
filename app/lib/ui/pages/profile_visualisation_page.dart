import 'package:app/logic/authentication_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/pages/profile_edit_page.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:app/ui/widgets/profile/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



/// Main page for displaying the user information
///
/// There are 3 possible scenarios :
///   - the [ProfileProvider] still load the user information, in this case the
///     [ProfileLoading] is displayed
///   - he profile provider encountered an error, in this case the [ProfileError]
///     is displayed
///   - the user information is loaded, the [ProfileView] is displayed
/// 
/// So, we user a [Consumer] to listen the [ProfileProvider] state and display 
/// the right widget according to it.
/// The profile provider state is represented by the [ProfileProviderState]
/// enumeration.
/// 
/// Note: the user can try a reload if an error occured thanks to the 
/// [ProfileError] widget.
class ProfileVisualisationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            switch (profileProvider.state) {
              case ProfileProviderState.not_initialized:
                return ProfileLoading();
              case ProfileProviderState.error:
                return ProfileError(onPressed: () => forceReload(context));
              case ProfileProviderState.initialized:
              default: 
                return ProfileView(user: profileProvider.user);
            }
          }
        ),
      )
    );
  }

  /// Try to load again the user information
  forceReload(context) {
    Provider.of<ProfileProvider>(context, listen: false).loadUser();
  }
}



/// Simple widget to display a loading screen
///
/// Note: For now it's an explicit screen loading, but in the future it can
///       be interesting to implement an skeleton screen loading
///       See : https://uxdesign.cc/what-you-should-know-about-skeleton-screens-a820c45a571a
class ProfileLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.profileLoading)
    );
  }
}



/// Simple widget to display an error message if the profile loading failed
///
/// There is an informational text and a button to reaload the profile. The
/// loading process has to be in the [onPressed] function
class ProfileError extends StatelessWidget {

  final Function onPressed;
  
  ProfileError({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(Strings.profileError),
          FlexSpacer(),
          Button(
            child: Text(Strings.profileErrorRetry),
            critical: true,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}



/// The widget to display the user information
///
/// It takes the user as parameter and display his information in a scroll view.
/// Nothing special here.
/// 
/// The entier profil scrollable column is wrapped inside a stack to positionned
/// the [ProfileMenu] a the top right corner.
class ProfileView extends StatelessWidget {

  final User user;
  
  ProfileView({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfilePicture(
                url: user.urlPhoto
              ),
              Container(
                padding: Dimens.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProfileHeader(
                      user: user, 
                      onEdit: () => editProfile(context),
                    ),
                    ProfileItemList(
                      user: user,
                    ),
                    FlexSpacer.big(),


                    // RaisedButton(child: Text("TEST"), onPressed: () => Navigator.push(context, 
                    // MaterialPageRoute(builder: (_) => ActivityView(activity: Activity(),))),)
                  ],
                )
              )
            ],
          ),
        ),
        Positioned(
          top: 0, right: 0,
          child: ProfileMenu()
        ),
      ]
    );
  }

  editProfile(context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProfileEditPage(user: user)
    ));
  }
}



/// The pop up menu for the profile view
///
/// It's a [PopupMenuButton] with the list of action available
class ProfileMenu extends StatelessWidget {

  static const int _signOut = 0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => action(context, value),
      itemBuilder: (_) => <PopupMenuEntry<int>>[
        PopupMenuItem(
          value: _signOut,
          child: Text(Strings.profileSignOut),
        ),
        PopupMenuItem(
          value: 999,
          child: Text(Strings.profileDelete),
        )
      ],
    );
  }

  /// Do the corresponding processing according to the [action]
  /// 
  /// [action] is an integer represents the action to do, constants are declared
  /// in the top of the class (e.g [_signOut])
  action(context, action) {
    switch (action) {
      case _signOut:
        Provider.of<AuthenticationProvider>(context, listen: false).signOut();
        break;
      default:
        showSnackbar(
          context: context, 
          content: Text(Strings.availableSoon), 
          critical: true
        );
    }
  }
}



/// The profile header with the username and the button to edit the profile
///
/// Just a row with the username (that take the mode available space) and the
/// edit button to the right
class ProfileHeader extends StatelessWidget {

  final User user;
  final Function onEdit;
  
  ProfileHeader({@required this.user, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final username = user.name??Strings.profileUnknownName;
    return Row(
      children: <Widget>[
        Expanded(
          child: PageHeader(
            title: Text(username), 
          ),
        ),
        Button(
          child: Text(Strings.profileEdit),
          onPressed: onEdit,
        )
      ],
    );
  }
}



/// A column of [ProfileItem] corresponding to all user information
///
/// e.g : description, age, country, etc.
/// Nothing special here.
class ProfileItemList extends StatelessWidget {

  final User user;
  
  ProfileItemList({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileItem(
          label: Strings.profileDescription, 
          content: user.description
        ),
        ProfileItem(
          label: Strings.profileAge,
          content: user.age?.toString(),
        ),
        ProfileItem(
          label: Strings.profileCountry, 
          content: user.country
        ),
        ProfileItem(
          label: Strings.profileSpokenLanguages, 
          content: user.spokenLanguages
        ),
      ],
    );
  }
}



/// Display an information of the user profile (for example the descrption)
///
/// Display the information label (e.g : "Country") and the actual information
/// (e.g. Brazil)
class ProfileItem extends StatelessWidget {

  final String label;
  final String content;

  ProfileItem({@required this.label, @required this.content});
  
  @override
  Widget build(BuildContext context) {
    return content == null || content.isEmpty
      ? Container()
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.subtitle2),
          Text(content),
          FlexSpacer()
      ],
    );
  }
}
