import 'package:app/ui/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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