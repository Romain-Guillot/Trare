import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// TODO
class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(Strings.unexpectedError)
      ),
    );
  }
}


/// Simple widget to display an error message with a reload button
///
/// There is an informational text and a button to trigger a reload action. The
/// loading process has to be in the [onReload] function
class ErrorWidgetWithReload extends StatelessWidget {

  final String message;
  final Function onReload;
  
  ErrorWidgetWithReload({@required this.message, @required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(message),
          FlexSpacer(),
          Button(
            child: Text(Strings.reload),
            critical: true,
            onPressed: onReload,
          )
        ],
      ),
    );
  }
}