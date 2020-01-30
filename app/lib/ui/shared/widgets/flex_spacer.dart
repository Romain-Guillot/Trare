import 'package:app/ui/shared/values.dart';
import 'package:flutter/widgets.dart';


/// Widget used to add spacing (padding) between widgets
/// 
/// Used typically in [Row] or [Column].
/// It will create a square widget of [Values.normalSpacing]
/// If you want a bigger space, set the flag [big] to true
class FlexSpacer extends StatelessWidget {
  final bool big;

  FlexSpacer({this.big = false});

  @override
  Widget build(BuildContext context) {
    final space = big ? Values.bigSpacing : Values.normalSpacing;
    return SizedBox(
      width: space,
      height: space,
    );
  }
}