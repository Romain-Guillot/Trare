import 'package:app/models/user.dart';
import 'package:app/ui/widgets/profile/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


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
      title: Text("${user.name}, ${user.age}"),
      subtitle: Text(user.spokenLanguages),
      onTap: onTap,
    );
  }
}