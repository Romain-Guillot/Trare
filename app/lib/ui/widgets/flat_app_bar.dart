import 'package:app/ui/shared/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


///
///
class FlatAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget action;
  final bool main;


  FlatAppBar({this.action, this.main = false});

  @override
  Widget build(BuildContext context) {
    var parentRoute = ModalRoute.of(context);
    var canPop = parentRoute?.canPop ?? false;
    var elemsPadding = const EdgeInsets.all(5.0);
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: elemsPadding,
          child: action,
        )
      ],
      leading: !canPop ? null : Padding(
        padding: elemsPadding,
        child: InkWell(     
          borderRadius: Dimens.rounedBorderRadius,   
          child: Icon(Icons.close),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}