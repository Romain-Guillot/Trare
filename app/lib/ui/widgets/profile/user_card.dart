import 'package:app/models/user.dart';
import 'package:app/ui/widgets/profile/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



/// Widget to display information about an user (name, age, etc)
///
/// It takes the [user] as parameter and an optionnal callback [onTap].
/// 
/// The layout is a [ListTile] with the following information :
///   - the user profile picture
///   - the user name
///   - the user age
///   - the user spoken languages
class UserCard extends StatelessWidget {

  final User user;
  final Function onTap;

  UserCard({@required this.user, this.onTap});

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
      onTap: onTap,
    );
  }
}