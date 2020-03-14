import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoCardWidget extends StatelessWidget {

  final Widget child;

  InfoCardWidget({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: Dimens.borderRadius,
        color: Colors.yellow[100],
      ),
      padding: EdgeInsets.all(Dimens.normalSpacing),
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.yellow[900]),
        child: Row(
          children: <Widget>[
            Icon(Icons.info_outline, color: Colors.yellow[900]),
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