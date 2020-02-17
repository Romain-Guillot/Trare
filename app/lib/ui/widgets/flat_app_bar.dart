import 'package:app/ui/shared/dimens.dart';
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

  final Widget action;

  FlatAppBar({this.action});

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