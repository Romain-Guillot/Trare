import 'package:app/shared/res/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/// Display a button to pop the current page of the navigation page
///
/// If no page can be poped, nothing is displayed (empty container)
class NavigatorBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parentRoute = ModalRoute.of(context);
    var canPop = parentRoute?.canPop ?? false;
    return !canPop ? Container() : SizedBox(
      width: 45,
      height: 45 ,
      child: InkWell(     
        borderRadius: Dimens.rounedBorderRadius,   
        child: Icon(Icons.close),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}