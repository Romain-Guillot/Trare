import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/// Display a page header with a title and a subtitle (both are optionnal)
///
/// It will display with the correct style, the page title (if not null) and
/// the page subtitle (is not null).
class PageHeader extends StatelessWidget {

  final Widget title;
  final Widget subtitle;

  PageHeader({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var titleStyle = textTheme.headline1;
    var subtitleStyle = TextStyle(fontSize: titleStyle.fontSize * 0.7, color: textTheme.caption.color);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          DefaultTextStyle(
            child: title,
            style: titleStyle
          ),
        if (subtitle != null)
          DefaultTextStyle(
            child: subtitle,
            style: subtitleStyle
          ),
      ],
    );
  }
}