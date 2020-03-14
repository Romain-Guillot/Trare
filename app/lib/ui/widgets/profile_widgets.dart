import 'package:app/models/user.dart';
import 'package:app/ui/pages/profile_visualisation_page.dart';
import 'package:app/ui/shared/assets.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/main.dart';



/// Widget to display information about an user (name, age, etc)
///
/// It takes the [user] as parameter and can be clickable if the flag 
/// [isClickable] is set to true. If so, the page [UserProfileVisualisationPage]
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
           child: ProfilePicture(url: user?.urlPhoto, rounded: true,)
         )
      ),
      title: Text(user?.name??"" + (user?.age != null ? ", ${user.age}" : "")),
      subtitle: user?.spokenLanguages == null || user.spokenLanguages.isEmpty
                  ? null
                  : Text(user.spokenLanguages),
      onTap: !isClickable ? null : () => openUserProfile(context),
    );
  }

  openUserProfile(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: 
      (_) => UserProfileVisualisationPage(user: user)
    ));
  }
}


/// Display the user profile picture from the [url] of the default profile picture
///
/// If the url is non-null the image is displayed thanks to the [Image.network]
/// widget, else the [DefaultProfilePicture] is displayed.
/// 
/// The entire content is wrapped inside a [LayoutBuilder] to get the width
/// available to display a square image.
class ProfilePicture extends StatelessWidget {

  final String url;
  final bool rounded;
  
  ProfilePicture({@required this.url, this.rounded = false});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) { 
        var size = constraints.maxWidth;
        return ClipRRect(
          borderRadius: rounded ? Dimens.rounedBorderRadius : BorderRadius.zero,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: url == null
              ? DefaultProfilePicture()
              : CachedNetworkImage(
                  imageUrl: url,
                  errorWidget: (_, __, ___) => DefaultProfilePicture(),
                  placeholder: (_, __) => DefaultProfilePicture(),
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                )
          ),
        );
      }
    );
  }
}



class DefaultProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) { 
        final size = constraints.maxWidth;
        return Container(
          width: size,
          height: size,
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: SvgPicture.asset(
              Assets.defaultProfilePicture, 
              height: size / 2,
              color: Theme.of(context).colorScheme.onSurfaceLight,
            ),
          )
        );
      }
    );
  }
}