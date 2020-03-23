import 'package:app/shared/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/// Display a snack bar with [content] widget inside and an action button to
/// dismissed the snackbar.
/// 
/// If [critical] is set to false, the background color of the snackbar will
/// be [ThemeData.colorScheme.error]. Else, the background color will be
/// [ThemeData.colorScheme.primaryVariant]. Text color are the corresponding
/// [ThemeData.colorScheme.onError] and [ThemeData.colorScheme.onPrimary]
/// 
/// It is a single function (not wrapped in a class) as [showBottomSheet()] or
/// [showDialog()] for example.
showSnackbar({@required BuildContext context, @required Widget content, bool critical = false}) {
  final _colorScheme = Theme.of(context).colorScheme;
  final backColor = critical ? _colorScheme.error : _colorScheme.primaryVariant;
  final textColor = critical ? _colorScheme.onError : _colorScheme.onPrimary;
  
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: content
      ),
      backgroundColor: backColor,
      action: SnackBarAction( // remove the snackbar on the action button
        label: Strings.snakbarActionDismissed, 
        textColor: textColor,
        onPressed: Scaffold.of(context).removeCurrentSnackBar,
      ),
    )
  );
}