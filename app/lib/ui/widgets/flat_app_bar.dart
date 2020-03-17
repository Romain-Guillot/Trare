import 'package:app/ui/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



/// Create an AppBar for the application
/// 
/// There is NO title in the application app bars, so you can only provider
/// an action widget (typically a [Button]).
/// 
/// The app bar will automaically add a back button if it is a secodnary page
/// (if we can returned back to a previous page)
/// 
/// ```dart
/// Scaffold(
///   appBar: FlatAppBar(
///     action: Button(...)
///   )
/// )
/// ```
class FlatAppBar extends StatelessWidget implements PreferredSizeWidget {

  static double padding = 5.0;

  final Widget action;
  final Widget title;

  FlatAppBar({this.action, this.title});

  @override
  Widget build(BuildContext context) {
    var elemsPadding = EdgeInsets.all(padding);
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.headline1
        .copyWith(fontSize: theme.primaryTextTheme.headline6.fontSize);
    
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: elemsPadding,
          child: action,
        )
      ],
      leading:  Padding(
        padding: elemsPadding,
        child: NavigatorBackButton()
      ),
      title: title == null ? Container() : DefaultTextStyle(
        style: titleStyle,
        child: title
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}