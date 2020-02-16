import 'package:app/models/user.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/profile/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class UserCard extends StatelessWidget {

  final User user;

  UserCard({@required this.user});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var titleSyle = textTheme.subtitle1;
    var subtitleStyle = textTheme.bodyText2.copyWith(color: textTheme.caption.color);
    return Row(
      children: <Widget>[
        SizedBox(
          width: 60,
          height: 60,
          child: ProfilePicture(url: user.urlPhoto, rounded: true,)
          ),
        FlexSpacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${user.name}, ${user.age}",
              style: titleSyle
            ),
            Text(
              user.spokenLanguages,
              style: subtitleStyle,
            )
          ],
        )
      ],
    );
  }
}