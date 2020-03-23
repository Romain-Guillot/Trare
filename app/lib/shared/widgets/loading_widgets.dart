import 'package:app/shared/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/// TODO
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}



/// this is a simple [CircularProgressIndicator] that will be displayed when the
/// state of our [ActiviyExploreProvider] is LoadingInprogress
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        semanticsLabel: Strings.accessibilityLoadingLabel,
      ),
    );
  }
}