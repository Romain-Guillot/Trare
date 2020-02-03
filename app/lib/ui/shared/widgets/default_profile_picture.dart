import 'package:app/ui/shared/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/main.dart';

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