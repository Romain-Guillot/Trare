import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/// TODO
///
///
class Button extends StatelessWidget {
  final Widget icon;
  final Widget child;
  final Function onPressed;
  final bool critical;
  final Color color;

  Button({
    @required this.child, 
    @required this.onPressed, 
    this.icon,
    this.critical = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textColor = critical ? colorScheme.onError : colorScheme.primary;
    textColor = color != null ? color : textColor;
    var backColor = critical ? colorScheme.error : Colors.transparent;
    if (icon != null) {
      return FlatButton.icon(
        color: backColor,
        textColor: textColor,
        onPressed: onPressed, 
        icon: icon, 
        label: child
      );
    } else {
      return FlatButton(
        child: child,
        color: backColor,
        textColor: textColor,
        onPressed: onPressed,
      );
    }
    
  }
}
