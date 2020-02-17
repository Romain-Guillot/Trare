import 'package:app/models/user.dart';
import 'package:app/ui/pages/profile_visualisation_page.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/profile/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



/// Widget to display information about an user (name, age, etc)
///
/// It takes the [user] as parameter and can be clickable if the flag 
/// [isClickable] is set to true. If so, the page [ProfileVisualisationPage]
/// will be opened to display all the user information.
/// 
/// The layout is a [ListTile] with the following information :
///   - the user profile picture
///   - the user name
///   - the user age
///   - the user spoken languages
class UserCard extends StatelessWidget {

  final User user;
  final bool isClickable;

  UserCard({@required this.user, this.isClickable = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: LayoutBuilder(
        builder: (_, constraints) =>
         SizedBox(
           width: constraints.maxHeight,
           height: constraints.maxHeight,
           child: ProfilePicture(url: user.urlPhoto, rounded: true,)
         )
      ),
      title: Text(user.name + (user.age != null ? ", ${user.age}" : "")),
      subtitle: user.spokenLanguages == null || user.spokenLanguages.isEmpty
                  ? null
                  : Text(user.spokenLanguages),
      onTap: !isClickable ? null : () => openUserProfile(context),
    );
  }

  openUserProfile(context) {
    showSnackbar(
      context: context, 
      content: Text(Strings.availableSoon),
      critical: true,
    );
  }
}