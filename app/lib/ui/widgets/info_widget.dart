import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:app/main.dart';

class InfoCardWidget extends StatelessWidget {

  final Widget child;

  InfoCardWidget({@required this.child});

  @override
  Widget build(BuildContext context) {
    var frontColor = Theme.of(context).colorScheme.onInfo;
    var backColor = Theme.of(context).colorScheme.info;
    return Container(
      decoration: BoxDecoration(
        borderRadius: Dimens.borderRadius,
        color: backColor,
      ),
      padding: EdgeInsets.all(Dimens.normalSpacing),
      child: DefaultTextStyle(
        style: TextStyle(color: frontColor),
        child: Row(
          children: <Widget>[
            Icon(Icons.info_outline, color: frontColor),
            FlexSpacer(),
            Expanded(
              child: child
            )
          ],
        ),
      )
    );
  }
}