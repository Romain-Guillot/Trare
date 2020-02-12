import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget action;
  final bool main;

  FlatAppBar({this.action, this.main = false});

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    return AppBar(
      actions: <Widget>[action],
      leading: !canPop ? null : IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}