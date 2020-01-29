import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final bool critical;

  Button({
    @required this.child, 
    @required this.onPressed, 
    this.critical = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = critical ? colorScheme.onError : colorScheme.primary;
    final backColor = critical ? colorScheme.error : Colors.transparent;
    return FlatButton(
      child: child,
      color: backColor,
      textColor: textColor,
      onPressed: onPressed,
    );
  }
}