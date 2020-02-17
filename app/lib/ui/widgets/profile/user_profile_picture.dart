import 'package:app/ui/shared/assets.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/main.dart';


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
              : Image.network(
                  url,
                  width: size,
                  height: size,
                  fit: BoxFit.fitWidth,
                  cacheHeight: Dimens.maxImageResolution,
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