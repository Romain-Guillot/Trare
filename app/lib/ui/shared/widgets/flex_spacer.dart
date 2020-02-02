import 'package:app/ui/shared/dimens.dart';
import 'package:flutter/widgets.dart';


/// Widget used to add spacing (padding) between widgets
/// 
/// Used typically in [Row] or [Column].
/// It will create a square widget of [Dimens.normalSpacing]
/// If you want a bigger space, set the flag [big] to true
/// If you want smaller space, set the flag [small] to true
class FlexSpacer extends StatelessWidget {
  final bool big;
  final bool small;

  FlexSpacer({
    this.big = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    var space = Dimens.normalSpacing;
    if (big) space = Dimens.bigSpacing;
    if (small) space = Dimens.smallSpacing;
    return SizedBox(
      width: space,
      height: space,
    );
  }
}